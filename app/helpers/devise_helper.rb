module DeviseHelper
  def sm?
    browser.device.tablet?
  end

  def xs?
    browser.device.mobile?
  end

  def md?
    !(browser.device.mobile? || browser.device.tablet?)
  end
end