require "rails_helper"

RSpec.describe "list all the bucketlists", type: :request do
  before(:all) do
    @user = create(:user, active_status: true)
    token = token_generator(@user)
    @headers = {
      "AUTHORIZATION" => token,
      "Content-Type" => "application/json",
      "ACCEPT" => "application/vnd.Bucketlist.v1"
    }
  end

  context "when the user has no bucketlist" do
    before(:all) do
      get "/bucketlists", {}, @headers
    end

    it "returns a status code of 200" do
      expect(response).to have_http_status 200
    end

    it "returns 'no bucketlist' message" do
      expect(json["message"]).to eq messages.no_bucket_list
    end
  end

  context "when the user has 3 bucketlist" do
    before(:all) do
      create_list(:bucket_list, 3, created_by: @user.id)
      create(:bucket_list)
      get "/bucketlists", {}, @headers
    end

    it "should return a 200 status code" do
      expect(response).to have_http_status 200
    end

    it "return bucketlist belonging to current user" do
      user_id = []
      json.each { |record| user_id << record["created_by"] }
      contain_user_id = user_id.all? { |id| id == @user.id }
      expect(contain_user_id).to eq true
    end

    it "should return a count of 3" do
      expect(json.count).to eq 3
    end
  end

  context "when user has no token " do
    before(:all) do
      headers = {
        "AUTHORIZATION" => nil,
        "Content-Type" => "application/json",
        "ACCEPT" => "application/vnd.Bucketlist.v1"
      }

      post "/bucketlists", { name: nil }.to_json, headers
    end

    it "should return NotAuthenticatedError" do
      expect(json["errors"]).to include messages.not_authenticated
    end

    it "should return a unauthorized status code" do
      expect(response).to have_http_status 401
    end
  end

  describe "Pagination" do
    before(:all) do
      BucketList.destroy_all
      @bucketlist = create_list(:bucket_list, 30, created_by: @user.id)
    end

    context "when user has 30 bucketlists and requests for page 2" do
      before(:all) do
        get "/bucketlists?page=2", {}, @headers
      end

      it "should return just 10 bucketlists" do
        expect(json.count).to eq 10
      end

      it "should return a status code of 200" do
        expect(response).to have_http_status 200
      end

      it "should return the correct bucketlist" do
        names = json.map { |record| record["name"] }
        expect(names[0]).to eq @bucketlist[20]["name"]
        expect(names[9]).to eq @bucketlist[29]["name"]
      end
    end

    context "when user has 30 bucketlist and requests with only limit of 5 " do
      before(:all) do
        get "/bucketlists?limit=5", {}, @headers
      end

      it "returns a status code of 200" do
        expect(response).to have_http_status 200
      end

      it "returns 5 records" do
        expect(json.count).to eq 5
      end
    end

    context "when requesting with limit and page number" do
      before(:all) do
        get "/bucketlists?page=2&limit=5", {}, @headers
      end

      it "returns a status code of 200" do
        expect(response).to have_http_status 200
      end

      it "returns the right number of bucketlist" do
        expect(json.count).to eq 5
      end

      it "returns the right bucketlists" do
        names = json.map { |hsh| hsh["name"] }
        expect(names[0]).to eq @bucketlist[5]["name"]
        expect(names[4]).to eq @bucketlist[9]["name"]
      end
    end
  end

  describe "Search" do
    before(:all) do
      create(:bucket_list, name: "Late Thirties", user: @user)
      create(:bucket_list, name: "Early Thirties", user: @user)
      create(:bucket_list, name: "Mid Twenties", user: @user)
    end

    context "when search query returns result" do
      before(:all) do
        get "/bucketlists?q=Thirties", {}, @headers
      end

      it "returns status code of 200" do
        expect(response).to have_http_status 200
      end

      it "returns the correct number of bucketlists" do
        expect(json.count).to eq 2
      end

      it "return bucketlist belonging to current user" do
        bucket_list_name = json.map { |record| record["name"] }
        result = bucket_list_name.all? { |name| name.include? "Thirties" }
        expect(result).to eq true
      end
    end

    context "when search query doesn't return result" do
      before(:all) do
        get "/bucketlists?q=party", {}, @headers
      end

      it "returns status code of 404" do
        expect(response).to have_http_status 404
      end

      it "returns 'no result found' message" do
        expect(json["errors"]).to include messages.no_result_found
      end
    end
  end
end
