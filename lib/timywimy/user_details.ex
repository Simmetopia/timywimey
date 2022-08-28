defmodule TimyWimey.UserDetails do
  @moduledoc """
  The UserDetails context.
  """

  import Ecto.Query, warn: false
  alias TimyWimey.Repo
  alias TimyWimey.UserDetails.UserDetail

  @doc """
  Returns the list of user_details.

  ## Examples

      iex> list_user_details()
      [%UserDetail{}, ...]

  """
  def list_user_details do
    Repo.all(UserDetail)
  end

  @doc """
  Gets a single user_detail.

  Raises `Ecto.NoResultsError` if the User detail does not exist.

  ## Examples

      iex> get_user_detail!(123)
      %UserDetail{}

      iex> get_user_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_detail!(id), do: Repo.get!(UserDetail, id)

  def get_user_detail_user!(id) do
    Repo.get_by!(UserDetail, user_id: id)
  end

  @doc """
  Creates a user_detail.

  ## Examples

      iex> create_user_detail(%{field: value})
      {:ok, %UserDetail{}}

      iex> create_user_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_detail(attrs \\ %{}, user) do
    %UserDetail{}
    |> UserDetail.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a user_detail.

  ## Examples

      iex> update_user_detail(user_detail, %{field: new_value})
      {:ok, %UserDetail{}}

      iex> update_user_detail(user_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_detail(%UserDetail{} = user_detail, attrs) do
    user_update =
      user_detail
      |> UserDetail.changeset(attrs)
      |> Repo.update()

    case user_update do
      {:ok, details} ->
        week = Timex.now() |> Timex.week_of_month()

        from(t in TimyWimey.WeeklyDigest.Week,
          update: [set: [weekly_hours: ^details.weekly_hours]],
          join: u in assoc(t, :user),
          join: ud in assoc(u, :details),
          where: ud.id == ^details.id,
          where: t.week_nr == ^week
        )
        |> Repo.update_all([])

        {:ok, details}

      e ->
        e
    end
  end

  @doc """
  Deletes a user_detail.

  ## Examples

      iex> delete_user_detail(user_detail)
      {:ok, %UserDetail{}}

      iex> delete_user_detail(user_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_detail(%UserDetail{} = user_detail) do
    Repo.delete(user_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_detail changes.

  ## Examples

      iex> change_user_detail(user_detail)
      %Ecto.Changeset{data: %UserDetail{}}

  """
  def change_user_detail(%UserDetail{} = user_detail, attrs \\ %{}) do
    UserDetail.changeset(user_detail, attrs)
  end
end
