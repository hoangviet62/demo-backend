require "rails_helper"

RSpec.describe ::Fetch::ListArticles do
  describe "Fetch::ListArticles" do
    let(:service_instance) { described_class.new(page: 1) }
    let(:url) { "http://google.com" }
    let(:html_content) do
      '<tbody>
   <tr class="athing" id="32274077">
      <td class="title" valign="top" align="right"><span class="rank">1.</span></td>
      <td class="votelinks" valign="top">
         <center>
            <a id="up_32274077" href="vote?id=32274077&amp;how=up&amp;goto=best">
               <div class="votearrow" title="upvote"></div>
            </a>
         </center>
      </td>
      <td class="title"><a href="https://tjukanovt.github.io/notable-people" class="titlelink">Map showing birthplaces of "notable people" around the world</a><span class="sitebit comhead"> (<a href="from?site=tjukanovt.github.io"><span class="sitestr">tjukanovt.github.io</span></a>)</span></td>
   </tr>
   <tr>
      <td colspan="2"></td>
      <td class="subtext">
         <span class="score" id="score_32274077">885 points</span> by <a href="user?id=jbesomi" class="hnuser">jbesomi</a> <span class="age" title="2022-07-29T07:32:02"><a href="item?id=32274077">1 day ago</a></span> <span id="unv_32274077"></span> | <a href="item?id=32274077">327&nbsp;comments</a>
      </td>
   </tr>
   <tr class="spacer" style="height:5px"></tr>
   <tr class="athing" id="32276017">
      <td class="title" valign="top" align="right"><span class="rank">2.</span></td>
      <td class="votelinks" valign="top">
         <center>
            <a id="up_32276017" href="vote?id=32276017&amp;how=up&amp;goto=best">
               <div class="votearrow" title="upvote"></div>
            </a>
         </center>
      </td>
      <td class="title"><a href="https://chronotrains-eu.vercel.app/" class="titlelink">How far can you go by train in 5h?</a><span class="sitebit comhead"> (<a href="from?site=chronotrains-eu.vercel.app"><span class="sitestr">chronotrains-eu.vercel.app</span></a>)</span></td>
   </tr>
</tbody>'
    end

    it "should return correct data" do
      allow(RubyReadabilityService).to receive(:call).and_return([Readability::Document.new(html_content, tags: %w[body p div pre code img h1 h2 h3 h4 li ul tt em b a ol blockquote center br table td tr tbody font i dl dt dd
                                                                                                                   span header figure main],
                                                                                                          attributes: %w[href rowspan border color src bgcolor width size align face class title id],
                                                                                                          remove_empty_nodes: false,
                                                                                                          ignore_image_format: %w[gif],
                                                                                                          encoding: false), nil])

      expect(service_instance.call.first).to have_key("id")
      expect(service_instance.call.first["id"]).to eq 32_274_077.to_s
    end
  end
end
