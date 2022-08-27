defmodule TimyWimey.UserDetailsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimyWimey.UserDetails` context.
  """

  @doc """
  Generate a user_detail.
  """
  def user_detail_fixture(attrs \\ %{}) do
    user = TimyWimey.UsersFixtures.user_fixture()
    {:ok, details} = TimyWimey.UserDetails.update_user_detail(user.details, attrs)

    details
  end
end
