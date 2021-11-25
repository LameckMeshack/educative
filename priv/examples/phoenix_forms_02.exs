defmodule MyApp.Helpers do
  # content_tag is part of the phoenix_html package
  def content_tag(tag, text), do: nil

  # START:phoenix_forms_0201
  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag(:span, translate_error(error))
    end
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, msg ->
      String.replace(msg, "%{#{key}}", to_string(value))
    end)
  end
  # END:phoenix_forms_0201
end

_ = """
# START:phoenix_forms_0202
<%= form_for @changeset, user_path(@conn, :create), fn f -> %>
  Name: <%= text_input f, :name %> <%= error_tag f, :name %>
  Age: <%= number_input f, :age %> <%= error_tag f, :age %>
  <%= submit "Submit" %>
<% end %>
# END:phoenix_forms_0202
"""

