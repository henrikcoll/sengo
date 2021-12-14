defmodule SengoWeb.Plugs.Locale do
  @moduledoc """
  Plug to set the user's preferred language
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.puts(get_locale(conn))

    case get_locale(conn) do
      nil ->
        conn

      locale ->
        update_gettext(locale)
        update_cookie(conn, locale)
    end
  end

  defp get_locale(conn) do
    conn.req_cookies["locale"] ||
      conn.params["locale"]
  end

  defp update_cookie(conn, locale) do
    if conn.req_cookies["locale"] != locale do
      put_resp_cookie(conn, "locale", locale)
    else
      # Do nothing
      conn
    end
  end

  defp update_gettext(locale) do
    Gettext.put_locale(SengoWeb.Gettext, locale)
  end
end
