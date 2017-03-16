# If called from 'daily_log_rotate' then return hard coded known date we can test against
class DateTime
  singleton_class.send(:alias_method, :actualnow, :now)
  define_singleton_method(:now) do
    called_from = caller[0].split[-1].tr("`'", '') || ''
    called_from == 'format_todays_date' ? DateTime.new(2017, 2, 1) : actualnow
  end
end
