defmodule TimyWimey.UserDetailsTest do
  use TimyWimey.DataCase

  alias TimyWimey.UserDetails

  describe "user_details" do
    alias TimyWimey.UserDetails.UserDetail

    import TimyWimey.UserDetailsFixtures

    @invalid_attrs %{name: nil, weekly_hours: nil}

    test "list_user_details/0 returns all user_details" do
      user_detail = user_detail_fixture()
      assert UserDetails.list_user_details() == [user_detail]
    end

    test "get_user_detail!/1 returns the user_detail with given id" do
      user_detail = user_detail_fixture()
      assert UserDetails.get_user_detail!(user_detail.id) == user_detail
    end

    test "create_user_detail/1 with valid data creates a user_detail" do
      valid_attrs = %{name: "some name", weekly_hours: 42}

      assert {:ok, %UserDetail{} = user_detail} = UserDetails.create_user_detail(valid_attrs)
      assert user_detail.name == "some name"
      assert user_detail.weekly_hours == 42
    end

    test "create_user_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserDetails.create_user_detail(@invalid_attrs)
    end

    test "update_user_detail/2 with valid data updates the user_detail" do
      user_detail = user_detail_fixture()
      update_attrs = %{name: "some updated name", weekly_hours: 43}

      assert {:ok, %UserDetail{} = user_detail} = UserDetails.update_user_detail(user_detail, update_attrs)
      assert user_detail.name == "some updated name"
      assert user_detail.weekly_hours == 43
    end

    test "update_user_detail/2 with invalid data returns error changeset" do
      user_detail = user_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = UserDetails.update_user_detail(user_detail, @invalid_attrs)
      assert user_detail == UserDetails.get_user_detail!(user_detail.id)
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
  end
end
