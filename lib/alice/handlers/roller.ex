defmodule Alice.Handlers.Roller do
  use Alice.Router

  command ~r/roll (?<term>.+)/i, :fetch
  route   ~r/roll (?<term>.+)/i, :fetch

  @doc "`roll 3d6+1` - rolls 3 d6s and adds 1"
  def fetch(conn) do
    conn
    |> generate_roll_response
    |> reply(conn)
  end

  def generate_roll_response(conn) do
    conn
    |> Alice.Conn.last_capture
    |> HighRoller.Parser.parse
    |> convert_roll_parse_to_message
  end

  defp convert_roll_parse_to_message(:error), do: "Curiouser and curiouser! I cannot make heads nor tails of that!"
  defp convert_roll_parse_to_message(parse) when is_integer(parse), do: Integer.to_string(parse)
  defp convert_roll_parse_to_message(parse), do: parse
end
