# START:phoenix_forms_0101
defmodule MyApp.User do
  import Ecto.Changeset
  use Ecto.Schema

  schema "users" do
    field :name, :string
    field :age, :integer
  end

  def changeset(user, params) do
    user
    |> cast(params, [:name, :age])
    |> validate_required(:name)
    |> validate_number(:age, greater_than: 0,
         message: "you are not yet born")
  end

end
# END:phoenix_forms_0101

_ = """
defmodule MyApp.FakeController do
  # START:phoenix_forms_0102
  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, changeset: changeset)
  end
  # END:phoenix_forms_0102
end
"""

_ = """
# START:phoenix_forms_0103
<%= form_for @changeset, user_path(@conn, :create), fn f -> %>
  Name: <%= text_input f, :name %>
  Age: <%= number_input f, :age %>
  <%= submit "Submit" %>
<% end %>
# END:phoenix_forms_0103
"""

_ = """
# START:phoenix_forms_0104
def create(conn, %{"user" => user_params}) do
  case Accounts.create_user(user_params) do
    {:ok, user} ->
      conn
      |> put_flash(:info, "User created successfully.")
      |> redirect(to: user_path(conn, :show, user))
    {:error, %Ecto.Changeset{} = changeset} ->
      render(conn, "new.html", changeset: changeset)
  end
end
# END:phoenix_forms_0104
"""

_ = """
# START:phoenix_forms_0105
def create_user(attrs \\ %{}) do
  %User{}
  |> User.changeset(attrs)
  |> Repo.insert()
end
# END:phoenix_forms_0105
"""

