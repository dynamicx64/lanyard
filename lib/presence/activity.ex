defmodule Lanyard.Presence.Activity do
  def build_pretty_activities(activities) do
    activities
    |> Enum.map(fn activity ->
      activity
      |> decorate_app_id()
      |> decorate_emoji()
    end)
  end

  defp decorate_app_id(activity) when is_map(activity) do
    case Map.get(activity, "application_id") do
      nil -> activity
      id when is_binary(id) -> activity
      id -> Map.put(activity, "application_id", "#{id}")
    end
  end

  defp decorate_app_id(activity), do: activity

  defp decorate_emoji(activity) when is_map(activity) do
    case Map.get(activity, "emoji") do
      emoji when is_map(emoji) ->
        id = case emoji["id"] do
          nil -> nil
          id when is_binary(id) -> id
          id -> "#{id}"
        end
        name = if is_binary(emoji["name"]), do: emoji["name"], else: nil
        base = %{"id" => id, "name" => name}
        normalized = if Map.has_key?(emoji, "animated"), do: Map.put(base, "animated", emoji["animated"]), else: base
        Map.put(activity, "emoji", normalized)
      _ ->
        activity
    end
  end

  defp decorate_emoji(activity), do: activity
end
