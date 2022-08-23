defmodule TimyWimey.UserDetailsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimyWimey.UserDetails` context.
  """

  @doc """
  Generate a user_detail.
  """
  def user_detail_fixture(attrs \\ %{}) do
    {:ok, user_detail} =
      attrs
      |> Enum.into(%{
        name: "some name",
        weekly_hours: 42
      })
      |> TimyWimey.UserDetails.create_user_detail()

    user_detail
  end
end
