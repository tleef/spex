defmodule Specx.Example do
  use Specx

  spec(:string, &is_binary/1)
  spec(:float, &is_float/1)

  spec(:"geo_point/lat", :float)
  spec(:"geo_point/lng", :float)

  spec(
    :geo_point,
    map([
      :"geo_point/lat",
      :"geo_point/lng"
    ])
  )

  spec(:"address/formatted", :string)
  spec(:"address.component/long_name", :string)
  spec(:"address.component/short_name", :string)
  spec(:"address.component/types", list(:string))

  spec(
    :"address/component",
    map([
      :"address.component/long_name",
      :"address.component/short_name",
      :"address.component/types"
    ])
  )

  spec(:"address/components", list(:"address/component"))
  spec(:"address/location", :geo_point)

  spec(
    :address,
    map([
      :"address/formatted",
      :"address/components",
      :"address/location"
    ])
  )

  spec(:"person/given_name", :string)
  spec(:"person/family_name", :string)
  spec(:"person/address", :address)

  spec(
    :person,
    map([
      :"person/given_name",
      :"person/family_name",
      :"person/address"
    ])
  )
end
