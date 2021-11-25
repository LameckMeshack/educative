_ = """
# START:appdesign_0201
def deps() do
  [{:music, in_umbrella: true}]
end
# END:appdesign_0201
"""

# START:appdesign_0202
defmodule Forum.Post do
  use Ecto.Schema

  schema "posts" do
    belongs_to :user, Accounts.User
  end
end

defmodule Accounts.User do
  use Ecto.Schema

  schema "user" do
    # This is not allowed due to the one-directional relationship
    # has_many :posts, Forum.Post
  end
end
# END:appdesign_0202

# START:appdesign_0203
defmodule Forum.Post do
  use Ecto.Schema
  import Ecto.Query

  # ...

  def from_user(user_or_users) do
    # assoc() can take a single schema or a list - we'll do the same
    user_ids = user_or_users |> List.wrap() |> Enum.map(& &1.id)
    from p in Post,
      where: p.user_id in ^user_ids
  end
end
# END:appdesign_0203


