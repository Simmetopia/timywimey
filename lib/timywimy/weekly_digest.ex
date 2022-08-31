defmodule TimyWimey.WeeklyDigest do
  @moduledoc """
  The WeeklyDigest context.
  """

  import Ecto.Query, warn: false
  alias TimyWimey.Repo

  alias TimyWimey.WeeklyDigest.Week

  @doc """
  Returns the list of weeks.

  ## Examples

      iex> list_weeks()
      [%Week{}, ...]

  """
  def list_weeks do
    Repo.all(Week)
  end

  def list_weeks_by_user(user) do
    Repo.all(from(w in Week, where: w.user_id == ^user.id))
  end

  def recover do
    weeks = Repo.all(Week) |> Repo.preload(:timesheets)

    weeks
    |> Enum.each(fn week ->
      case week.timesheets do
        [] ->
          delete_week(week)

        timesheets ->
          total_minutes =
            timesheets
            |> Enum.reject(fn w -> w.is_spare_time end)
            |> Enum.map(fn ts -> ts.minutes end)
            |> Enum.sum()

          total_hours =
            timesheets
            |> Enum.reject(fn w -> w.is_spare_time end)
            |> Enum.map(fn ts -> ts.hours end)
            |> Enum.sum()
            |> Timex.Duration.from_hours()
            |> Timex.Duration.to_minutes(truncate: true)
            |> Kernel.+(total_minutes)

          total_spare_minutes =
            timesheets
            |> Enum.filter(fn w -> w.is_spare_time end)
            |> Enum.map(fn ts -> ts.minutes end)
            |> Enum.sum()

          total_spare =
            timesheets
            |> Enum.filter(fn w -> w.is_spare_time end)
            |> Enum.map(fn ts -> ts.hours end)
            |> Enum.sum()
            |> Timex.Duration.from_hours()
            |> Timex.Duration.to_minutes(truncate: true)
            |> Kernel.+(total_spare_minutes)

          update_week(week, %{worked_time_minutes: total_hours, spare_time_minuts: total_spare})
      end
    end)
  end

  @doc """
  Gets a single week.

  Raises `Ecto.NoResultsError` if the Week does not exist.

  ## Examples

      iex> get_week!(123)
      %Week{}

      iex> get_week!(456)
      ** (Ecto.NoResultsError)

  """
  def get_week!(id), do: Repo.get!(Week, id)

  def get_week_by_week(week, user) do
    Repo.get_by(Week, week_nr: week, user_id: user.id)
  end

  def calculate_overtime(%TimyWimey.Users.User{} = user) do
    weeks =
      from(t in Week, where: t.user_id == ^user.id, order_by: [asc: :inserted_at]) |> Repo.all()

    weeks
    |> Enum.reduce(0, fn week, ot ->
      %Week{
        weekly_hours: weekly_hours,
        spare_time_minutes: spare_time_minutes,
        worked_time_minutes: worked_time_minutes
      } = week

      weekly_minutes = weekly_hours * 60

      d_ot = spare_time_minutes + worked_time_minutes - weekly_minutes
      final_ot = ot + (d_ot - spare_time_minutes)

      final_ot
    end)
  end

  @doc """
  Creates a week.

  ## Examples

      iex> create_week(%{field: value})
      {:ok, %Week{}}

      iex> create_week(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_week(attrs \\ %{}, user) do
    %Week{}
    |> Week.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a week.

  ## Examples

      iex> update_week(week, %{field: new_value})
      {:ok, %Week{}}

      iex> update_week(week, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_week(%Week{} = week, attrs) do
    week
    |> Week.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a week.

  ## Examples

      iex> delete_week(week)
      {:ok, %Week{}}

      iex> delete_week(week)
      {:error, %Ecto.Changeset{}}

  """
  def delete_week(%Week{} = week) do
    Repo.delete(week)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking week changes.

  ## Examples

      iex> change_week(week)
      %Ecto.Changeset{data: %Week{}}

  """
  def change_week(%Week{} = week, attrs \\ %{}) do
    Week.changeset(week, attrs)
  end
end
