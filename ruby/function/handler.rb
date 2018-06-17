require 'aws-sdk'
require 'pp'

def list_bucket_objects(name)

    # it uses the `~/.ws/credentials`
    client = Aws::S3::Client.new(endpoint: 'https://beta.scalewaydata.com')

    ret = []
    continuation_token = nil
    begin
        resp = client.list_objects_v2({ bucket: name })
        # PP.pp(resp)
        continuation_token = resp.continuation_token
        ret += resp.contents.map{|o| o.key}
    end while continuation_token

    return ret
end

class Handler
    def run(req)
        bucket_name = "tada"
        # bucket_name = "plex-fifou"
        regex = Regexp.new req.strip

        ret = []
        for key in list_bucket_objects(bucket_name)
            if regex.match(key)
                ret.push(key)
            end
        end

        return ret.inspect
    end
end
