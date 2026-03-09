defmodule BudgieWeb.PageController do
  use BudgieWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  # все параметры нужно задавать явно!!!
  # # /about?company=Demo   - (?company=Demo - это params)
  # def about(conn, params) do
  #   company = params |> Map.get("company", "unknown")
  #   render(conn, :about, company: company) # :about - layout(page_html)
  # end

  # /about/City?company=Demo   - (/City - это именованный параметр)
    def about(conn, %{"location" => location} = params) do
    company = params |> Map.get("company", "unknown")

    render(conn, :about, company: company, location: location)
  end

end
