defmodule TimyWimeyWeb.Icons do
  use TimyWimeyWeb, :component

  def user(assigns) do
    ~H"""
    <.icon name={:user} outlined={true} />
    """
  end

  def home(assigns) do
    ~H"""
    <.icon name={:home} outlined={true} />
    """
  end

  def timeheets(assigns) do
    ~H"""
    <.icon name={:document_text} outlined={true} />
    """
  end

  def settings(assigns) do
    ~H"""
    <.icon name={:cog_6_tooth} outlined={true} />
    """
  end

  def logout(assigns) do
    ~H"""
    <.icon name={:arrow_right_on_rectangle} outlined={true} />
    """
  end

  def up_icon(assigns) do
    ~H"""
    <.icon name={:arrow_up_right} />
    """
  end

  def down_icon(assigns) do
    ~H"""
    <.icon name={:arrow_down_right} />
    """
  end

  def user_clock(assigns) do
    ~H"""
    <.icon name={:clock} outlined={true} />
    """
  end
end
