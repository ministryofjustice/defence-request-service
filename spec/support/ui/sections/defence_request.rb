class DefenceRequestSection < SitePrism::Section
  element :time_of_arrival, ".time-of-arrival"
  element :detainee_name, ".name"
  element :offences, ".offences"
  element :dscc, ".dscc"
end