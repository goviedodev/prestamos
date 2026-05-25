defmodule Prestamos.Cldr do
  use Cldr,
    locales: ["es-CL"],
    default_locale: "es-CL",
    providers: [Cldr.Number]
end
