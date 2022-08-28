defmodule TimyWimey.UserDetailsTest do
  use TimyWimey.DataCase, async: true

  alias TimyWimey.UserDetails

  describe "user_details" do
    alias TimyWimey.UserDetails.UserDetail

    import TimyWimey.UserDetailsFixtures

    test "list_user_details/0 returns all user_details" do
      user_detail = user_detail_fixture()
      [%UserDetail{} = user] = UserDetails.list_user_details()

      assert user_detail.id == user.id
    end

    test "get_user_detail!/1 returns the user_detail with given id" do
      user_detail = user_detail_fixture()
      assert UserDetails.get_user_detail!(user_detail.id).id == user_detail.id
    end

    test "update_user_detail/2 with valid data updates the user_detail" do
      user_detail = user_detail_fixture()
      update_attrs = %{name: "some updated name", weekly_hours: 43}

      assert {:ok, %UserDetail{} = user_detail} =
               UserDetails.update_user_detail(user_detail, update_attrs)

      assert user_detail.name == "some updated name"
      assert user_detail.weekly_hours == 43
    end

    test "delete_user_detail/1 deletes the user_detail" do
      user_detail = user_detail_fixture()
      assert {:ok, %UserDetail{}} = UserDetails.delete_user_detail(user_detail)
      assert_raise Ecto.NoResultsError, fn -> UserDetails.get_user_detail!(user_detail.id) end
    end

    test "change_user_detail/1 returns a user_detail changeset" do
      user_detail = user_detail_fixture()
      assert %Ecto.Changeset{} = UserDetails.change_user_detail(user_detail)
    end

    test "change_user_detail/1 returns a user_detail changeset and updates current weeks time" do
      user_detail = user_detail_fixture()
      user = TimyWimey.Users.get_user!(user_detail.user.id)
      week = TimyWimey.WeeklyDigestFixtures.week_fixture_user(user)

      update_attrs = %{weekly_hours: 5}

      assert {:ok, %UserDetail{} = user_detail} =
               UserDetails.update_user_detail(user_detail, update_attrs)

      week = TimyWimey.WeeklyDigest.get_week!(week.id)

      assert user_detail.weekly_hours == week.weekly_hours

    end
  end
end
