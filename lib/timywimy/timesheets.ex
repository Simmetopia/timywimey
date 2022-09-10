defmodule TimyWimey.Timesheets do
  @moduledoc """
  The Timesheets context.
  """

  import Ecto.Query, warn: false
  alias TimyWimey.Repo

  alias TimyWimey.Timesheets.Timesheet
  alias TimyWimey.WeeklyDigest.Week

  @doc """
  Returns the list of timesheets.

  ## Examples

      iex> list_timesheets()
      [%Timesheet{}, ...]

  """
  def list_timesheets(user) do
    uq = timesheet_by_user_query(user)

    from([timesheet: timesheet, week: w] in uq,
      order_by: [desc: w.week_nr],
      preload: [:week]
    )
    |> Repo.all()
  end

  defp timesheet_by_user_query(user) do
    from(p in Timesheet,
      as: :timesheet,
      join: w in assoc(p, :week),
      as: :week,
      join: u in assoc(w, :user),
      where: u.id == ^user.id
    )
  end

  def time_sheets_week(week, diff_weeks \\ 0) do
    date =
      Date.utc_today()
      |> Date.add(diff_weeks * 7)
      |> Date.beginning_of_week()

    date = NaiveDateTime.new!(date, ~T[00:00:00.000])

    query = from(t in Timesheet, where: t.week_id == ^week.id, where: t.inserted_at > ^date)

    Repo.all(query)
  end

  def spare_time(%TimyWimey.Users.User{} = user) do
    timesheets_query = timesheet_by_user_query(user)

    query =
      from([timesheet: t] in timesheets_query,
        select: %{total_hours: sum(t.hours), total_minuts: sum(t.minutes)}
      )

    q1 =
      from([timesheet: t] in query,
        where: t.is_spare_time == false
      )

    q2 =
      from([timesheet: t] in query,
        where: t.is_spare_time == true
      )

    [%{total_hours: th_plus, total_minuts: tm_plus}] = Repo.all(q1)
    [%{total_hours: th, total_minuts: tm}] = Repo.all(q2)

    {h_p, m_p, _, _} = add_hours_and_minutes(th_plus, tm_plus)

    {h, m, _, _} = add_hours_and_minutes(th, tm)

    [first_timesheet_date] =
      from([timesheet: t] in timesheets_query,
        order_by: [asc: :inserted_at],
        limit: 1,
        select: t.inserted_at
      )
      |> Repo.all()

    %{timesheets_time: {h_p, m_p}, spare_time: {h, m}, first_timesheet: first_timesheet_date}
  end

  defp add_hours_and_minutes(nil, nil) do
    Timex.Duration.from_minutes(0) |> Timex.Duration.to_clock()
  end

  defp add_hours_and_minutes(nil, m) do
    Timex.Duration.from_minutes(m) |> Timex.Duration.to_clock()
  end

  defp add_hours_and_minutes(h, nil), do: h

  defp add_hours_and_minutes(h, m) do
    Timex.Duration.from_hours(h)
    |> Timex.Duration.add(Timex.Duration.from_minutes(m))
    |> Timex.Duration.to_clock()
  end

  @doc """
  Gets a single timesheet.

  Raises `Ecto.NoResultsError` if the Timesheet does not exist.

  ## Examples

      iex> get_timesheet!(123)
      %Timesheet{}

      iex> get_timesheet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timesheet!(id), do: Repo.get!(Timesheet, id) |> Repo.preload(:week)

  @doc """
  Creates a timesheet.

  ## Examples

      iex> create_timesheet(%{field: value})
      {:ok, %Timesheet{}}

      iex> create_timesheet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timesheet(attrs \\ %{}, week) do
    res =
      %Timesheet{}
      |> Timesheet.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:week, week)
      |> Repo.insert()

    case res do
      {:ok, timesheet} ->
        minutes_worked =
          Timex.Duration.from_hours(timesheet.hours)
          |> Timex.Duration.add(Timex.Duration.from_minutes(timesheet.minutes))
          |> Timex.Duration.to_minutes(truncate: true)

        case timesheet.is_spare_time do
          false ->
            from(t in Week,
              where: t.id == ^week.id,
              update: [inc: [worked_time_minutes: ^minutes_worked]]
            )
            |> Repo.update_all([])

          true ->
            from(t in Week,
              where: t.id == ^week.id,
              update: [inc: [spare_time_minutes: ^minutes_worked]]
            )
            |> Repo.update_all([])
        end

        {:ok, timesheet}

      default ->
        default
    end
  end

  @doc """
  Updates a timesheet.

  ## Examples

      iex> update_timesheet(timesheet, %{field: new_value})
      {:ok, %Timesheet{}}

      iex> update_timesheet(timesheet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timesheet(%Timesheet{} = timesheet, attrs) do
    res =
      timesheet
      |> Timesheet.changeset(attrs)
      |> Repo.update()

    to_u = if timesheet.is_spare_time, do: :spare_time_minutes, else: :worked_time_minutes

    case res do
      {:ok, timesheet_n} ->
        new_t = if timesheet_n.is_spare_time, do: :spare_time_minutes, else: :worked_time_minutes

        minutes_worked =
          Timex.Duration.from_hours(timesheet_n.hours)
          |> Timex.Duration.add(Timex.Duration.from_minutes(timesheet_n.minutes))
          |> Timex.Duration.to_minutes(truncate: true)

        Ecto.Multi.new()
        |> Ecto.Multi.update_all(
          :add,
          from(t in Week,
            where: t.id == ^timesheet_n.week_id
          ),
          inc: [{new_t, minutes_worked}]
        )
        |> Ecto.Multi.update_all(
          :remove,
          from(t in Week,
            where: t.id == ^timesheet.week_id
          ),
          inc: [{to_u, minutes_worked * -1}]
        )
        |> Repo.transaction()

        {:ok, timesheet_n}

      default ->
        default
    end
  end

  @doc """
  Deletes a timesheet.

  ## Examples

      iex> delete_timesheet(timesheet)
      {:ok, %Timesheet{}}

      iex> delete_timesheet(timesheet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timesheet(%Timesheet{} = timesheet) do
    Repo.delete(timesheet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timesheet changes.

  ## Examples

      iex> change_timesheet(timesheet)
      %Ecto.Changeset{data: %Timesheet{}}

  """
  def change_timesheet(%Timesheet{} = timesheet, attrs \\ %{}) do
    Timesheet.changeset(timesheet, attrs)
  end
end
