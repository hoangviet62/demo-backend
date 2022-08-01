module FetchDataHelper
  def source_from(cache_key:, resource:)
    start_time = Time.current.to_i
    data = JSON.parse(CachingService.new.get_data(cache_key))
    end_time = Time.current.to_i
    total = end_time - start_time
    { data: data, source_from: "Cached Service with key = #{cache_key}", duration: humanize(total.zero? ? 1 : total) }
  rescue StandardError
    start_time = Time.current.to_i
    data = resource.call
    end_time = Time.current.to_i
    total = end_time - start_time
    { data: data, source_from: "API Service", duration: humanize(total.zero? ? 1 : total) }
  end
end
