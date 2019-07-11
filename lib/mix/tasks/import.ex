defmodule Mix.Tasks.Import do
  use Mix.Task

  alias Koroibos.{Repo, Sport, Team, Olympian, Event}

  def run(filepath) do
    Mix.Task.run "app.start"
    case stream_file(hd(filepath)) do
      {:error, message} -> message
      rows -> load_data(rows)
    end
  end

  defp stream_file(filepath) do
    try do
      filepath
      |> Path.expand(__DIR__ <> "../../../../")
      |> File.stream!
      |> CSV.decode(headers: true)
    rescue
      error -> {:error, error}
    end
  end

  defp load_data(rows) do
    Repo.transaction(fn ->
      rows
      |> Enum.each(fn chunk ->
        create_row(chunk)
      end)
    end)
  end

  defp create_row({:ok, row}) do
    team = find_or_create_team(row)
    sport = find_or_create_sport(row)
    event = find_or_create_event(sport, row)
    olympian = find_or_create_olympian(team, sport, event, row)
    create_associations(olympian, event, row)
  end

  defp find_or_create_team(%{"Team" => team}) do
    case Repo.get_by(Team, name: team) do
      nil -> %Team{name: team} |> Repo.insert!()
      result -> result
    end
  end

  defp find_or_create_sport(%{"Sport" => sport}) do
    case Repo.get_by(Sport, name: sport) do
      nil -> %Sport{name: sport} |> Repo.insert!()
      result -> result
    end
  end

  defp find_or_create_event(sport, %{"Event" => name}) do
    case Repo.get_by(Event, name: name) do
      nil -> Event.changeset(%Event{}, %{name: name, sport_id: sport.id}) |> Repo.insert!()
      result -> result
    end
  end

  defp find_or_create_olympian(team, sport, event, %{"Name" => name, "Age" => age, "Sex" => sex, "Height" => height, "Weight" => weight}) do
    sex = (sex == "F" && :Female) || :Male
    case Repo.get_by(Olympian, name: name, age: age) do
      nil -> Olympian.changeset(%Olympian{}, %{name: name, age: age, height: parse_num(height), weight: parse_num(weight), sex: sex, team_id: team.id, sport_id: sport.id})
        |> Ecto.Changeset.put_assoc(:events, [event])

      result -> changeset = result |> Repo.preload(:events) |> Ecto.Changeset.change()
        Ecto.Changeset.put_assoc(changeset, :events, [event | changeset.data.events])
    end
  end

  defp create_associations(olympian, event, %{"Medal" => medal}) do
    olympian = Repo.insert_or_update!(olympian)
    case medal do
      "Gold" -> Ecto.build_assoc(olympian, :medals, %{medal: :Gold, event_id: event.id})
      "Silver" -> Ecto.build_assoc(olympian, :medals, %{medal: :Silver, event_id: event.id})
      "Bronze" -> Ecto.build_assoc(olympian, :medals, %{medal: :Bronze, event_id: event.id})
      _ -> olympian
    end
  end

  # Adds custom parser for use on height and weight feilds due to presence of "NA" values in data
  defp parse_num(text) do
    case Integer.parse(text) do
      {integer, _} -> integer
      :error -> nil
    end
  end
end