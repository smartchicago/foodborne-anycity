# Load the localization file, or grab from ENV
localization_file = "#{Rails.root}/config/localization.yml"
L10N = File.exist?(localization_file) ? YAML.load_file(localization_file) : ENV
