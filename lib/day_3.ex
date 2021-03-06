defmodule AdventOfCode.Day3 do

  def divide_movements(movement_list) do
    moves = String.codepoints(movement_list) |> filter_invalid_moves
    divide_movements(moves, [], [], true)
  end

  defp divide_movements([current | moves], santa_moves, robot_moves, true) do
    divide_movements(moves, santa_moves ++ [current], robot_moves, false)
  end
  
  defp divide_movements([current | moves], santa_moves, robot_moves, false) do
    divide_movements(moves, santa_moves, robot_moves ++ [current], true)
  end

  defp divide_movements([], santa_moves, robot_moves, _) do
    [Enum.join(santa_moves), Enum.join(robot_moves)]
  end

  # keep a coordinate list, grows with each movement
  def track_movements(movement_list) do
    moves = String.codepoints(movement_list)
    track_movements(moves, [[0,0]])
  end

  defp track_movements([current_move | moves], history) do
    [current_x, current_y] = List.last(history)

    cond do
      current_move == "^" -> track_movements(
        moves, history ++ [[current_x, current_y + 1]])
      current_move == "v" -> track_movements(
        moves, history ++ [[current_x, current_y - 1]])
      current_move == ">" -> track_movements(
        moves, history ++ [[current_x + 1, current_y]])
      current_move == "<" -> track_movements(
        moves, history ++ [[current_x - 1, current_y]])
      true -> track_movements(moves, history)
    end
  end

  defp track_movements([], history), do: history

  def unique_destinations_from_movements(movements) do
    track_movements(movements)
    |> unique_destinations
  end

  def unique_destinations(coords) do
    unique_destinations(coords, [])
    |> Enum.count
  end

  defp unique_destinations([current | coords], memory) do
    cond do
      Enum.find(memory, fn(x) -> x == current end) == nil ->
        unique_destinations(coords, memory ++ [current])
      true -> unique_destinations(coords, memory)
    end
  end

  defp unique_destinations([], memory), do: memory

  defp filter_invalid_moves(movements) do
    Enum.filter(movements, fn(move) ->
      Regex.match?(~r/\^|v|>|</, move)
    end)
  end
end
