defmodule Koroibos.OlympianTest do
  use Koroibos.DataCase

  alias Koroibos.{Olympian, Team, Sport, Event, EventMedalist}

  @valid_attrs %{
    name: "Tim",
    age: 29,
    height: 95,
    weight: 90,
    sex: :Male,
    sport_id: 1,
    team_id: 1
  }

  test "Valid olympians" do
    changeset = Olympian.changeset(%Olympian{}, @valid_attrs)

    assert changeset.valid?
  end

  test "name is required" do
    changeset = Olympian.changeset(%Olympian{}, Map.delete(@valid_attrs, :name))

    refute changeset.valid?
    assert {:name, ["can't be blank"]} in errors_on(changeset)
  end

  test "name must at least length 1" do
    changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | name: ""})

    refute changeset.valid?
    assert {:name, ["can't be blank"]} in errors_on(changeset)
  end

  test "Age is required" do
    changeset = Olympian.changeset(%Olympian{}, Map.delete(@valid_attrs, :age))

    refute changeset.valid?
    assert {:age, ["can't be blank"]} in errors_on(changeset)
  end

  test "Age must be greater than 0" do
    changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | age: 0})

    refute changeset.valid?
    assert {:age, ["must be greater than 0"]} in errors_on(changeset)
  end

  test "Age must be less than 100" do
    changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | age: 100})

    refute changeset.valid?
    assert {:age, ["must be less than 100"]} in errors_on(changeset)
  end

  test "Height is required" do
    changeset = Olympian.changeset(%Olympian{}, Map.delete(@valid_attrs, :height))

    refute changeset.valid?
    assert {:height, ["can't be blank"]} in errors_on(changeset)
  end

  test "Height must be greater than 0" do
    changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | height: 0})

    refute changeset.valid?
    assert {:height, ["must be greater than 0"]} in errors_on(changeset)
  end

  test "Weight is required" do
    changeset = Olympian.changeset(%Olympian{}, Map.delete(@valid_attrs, :weight))

    refute changeset.valid?
    assert {:weight, ["can't be blank"]} in errors_on(changeset)
  end

  test "Weight must be greater than 0" do
    changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | weight: 0})

    refute changeset.valid?
    assert {:weight, ["must be greater than 0"]} in errors_on(changeset)
  end

  test "Sex field must be male or female" do
    changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | sex: :Female})
    invalid_changeset = Olympian.changeset(%Olympian{}, %{@valid_attrs | sex: :anything})

    assert changeset.valid?
    refute invalid_changeset.valid?
    assert {:sex, ["is invalid"]} in errors_on(invalid_changeset)
  end

  describe "Olympian.all_with_medals" do
    setup do
      usa = %Team{name: "USA"} |> Repo.insert!()
      taekwondo = %Sport{name: "Taekwondo"} |> Repo.insert!()

      tim =
        %Olympian{name: "Tim", age: 29, sport_id: taekwondo.id, team_id: usa.id} |> Repo.insert!()

      jim =
        %Olympian{name: "Jim", age: 55, sport_id: taekwondo.id, team_id: usa.id} |> Repo.insert!()

      event = %Event{name: "Sparring", sport_id: taekwondo.id} |> Repo.insert!()
      %EventMedalist{olympian_id: tim.id, event_id: event.id, medal: :Gold} |> Repo.insert!()
      {:ok, tim: tim, jim: jim}
    end

    test "Fetches all olympians from the database with medal count and relationships", %{tim: tim} do
      result = Olympian.all_with_medals()

      assert is_list(result)
      assert length(result) == 2
      assert [result_1, result_2] = result
      assert result_1.name == tim.name
      assert result_1.age == tim.age
      assert result_1.team == "USA"
      assert result_1.sport == "Taekwondo"
      assert result_1.total_medals_won == 1
      assert result_2.total_medals_won == 0
    end
  end

  describe "Olympian.youngest" do
    setup do
      usa = %Team{name: "USA"} |> Repo.insert!()
      taekwondo = %Sport{name: "Taekwondo"} |> Repo.insert!()

      tim =
        %Olympian{name: "Tim", age: 29, sport_id: taekwondo.id, team_id: usa.id} |> Repo.insert!()

      jim =
        %Olympian{name: "Jim", age: 55, sport_id: taekwondo.id, team_id: usa.id} |> Repo.insert!()

      event = %Event{name: "Sparring", sport_id: taekwondo.id} |> Repo.insert!()
      %EventMedalist{olympian_id: tim.id, event_id: event.id, medal: :Gold} |> Repo.insert!()
      {:ok, tim: tim, jim: jim}
    end

    test "Fetches the youngest olympian with medal count and relationships", %{tim: tim} do
      result = Olympian.youngest()

      assert is_list(result)
      assert length(result) == 1
      assert [result_1] = result
      assert result_1.name == tim.name
      assert result_1.age == tim.age
      assert result_1.team == "USA"
      assert result_1.sport == "Taekwondo"
      assert result_1.total_medals_won == 1
    end
  end

  describe "Olympian.oldest" do
    setup do
      usa = %Team{name: "USA"} |> Repo.insert!()
      taekwondo = %Sport{name: "Taekwondo"} |> Repo.insert!()

      tim =
        %Olympian{name: "Tim", age: 29, sport_id: taekwondo.id, team_id: usa.id} |> Repo.insert!()

      jim =
        %Olympian{name: "Jim", age: 55, sport_id: taekwondo.id, team_id: usa.id} |> Repo.insert!()

      event = %Event{name: "Sparring", sport_id: taekwondo.id} |> Repo.insert!()
      %EventMedalist{olympian_id: tim.id, event_id: event.id, medal: :Gold} |> Repo.insert!()
      {:ok, tim: tim, jim: jim}
    end

    test "Fetches the youngest olympian with medal count and relationships", %{jim: jim} do
      result = Olympian.oldest()

      assert is_list(result)
      assert length(result) == 1
      assert [result_1] = result
      assert result_1.name == jim.name
      assert result_1.age == jim.age
      assert result_1.team == "USA"
      assert result_1.sport == "Taekwondo"
      assert result_1.total_medals_won == 0
    end
  end
end
