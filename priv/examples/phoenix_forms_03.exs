# START:phoenix_forms_0301
defmodule MyApp.Address do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field :street, :string
    field :city, :string
  end

  def changeset(address, params) do
    cast(address, params, [:street, :city])
  end
end
# END:phoenix_forms_0301

_ = """
# START:phoenix_forms_0302
schema "users" do
  field :name, :string
  field :age, :integer

  embeds_one :address, Address
end
# END:phoenix_forms_0302
"""

defmodule MyApp.User do
  import Ecto.Changeset

  # START:phoenix_forms_0303
  def changeset(user, params) do
    user
    |> cast(params, [:name, :age])
    |> cast_embed(:address)
    |> validate_number(:age, greater_than: 0,
         message: "you are not yet born")
  end
  # END:phoenix_forms_0303
end

_ = """
# START:phoenix_forms_0304
<%= form_for @changeset, user_path(@conn, :create), fn f -> %>
  Name: <%= text_input f, :name %> <%= error_tag f, :name %>
  Age: <%= number_input f, :age %> <%= error_tag f, :age %>
  <%= inputs_for f, :address, fn fa -> %>
    Street: <%= text_input fa, :street %> <%= error_tag fa, :street %>
    City: <%= text_input fa, :city %> <%= error_tag fa, :city %>
  <% end %>
  <%= submit "Submit" %>
<% end %>
# END:phoenix_forms_0304
"""

_ = """
# START:phoenix_forms_0305
<%= inputs_for f, :address, append: [%Address{}], fn fa -> %>
  Street: <%= text_input fa, :street %> <%= error_tag fa, :street %>
  City: <%= text_input fa, :city %> <%= error_tag fa, :city %>
<% end %>
# END:phoenix_forms_0305
"""

