defmodule LiveViewTodo.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveViewTodo.Repo
  alias __MODULE__

  schema "items" do
    field :person_id, :integer
    field :status, :integer, default: 0
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:text, :person_id, :status])
    |> validate_required([:text])
  end

  @doc """
  Creates a item.

  ## Examples

    iex> create_item(%{text: "Learn LiveView"})
    {:ok, %Item{}}

    iex> create_item(%{text: nil})
    {:error, %Ecto.Changeset{}}
  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

    iex> get_item!(123)
    %Item{}

    iex> get_item!(456)
    ** (Ecto.NoResultsError)
  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Returns the list of items.

  ## Examples

    iex> list_items()
    [%Item{}, ...]
  """
  def list_items do
    Repo.all(Item)
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(id) do
    get_item!(id)
    |> Item.changeset(%{status: 2})
    |> Repo.update()
  end
end
