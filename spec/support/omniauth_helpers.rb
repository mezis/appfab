module OmniauthHelpers

  def build_auth_hash(first_name:nil, last_name:nil, email:nil)
    first_name ||= Faker::Name.first_name
    last_name  ||= Faker::Name.last_name
    email      ||= Faker::Internet.email
    full_name    = "#{first_name} #{last_name}"

    OmniAuth::AuthHash.new({
      provider:"google_oauth2",
      uid:"12345678",
      info:{
        name:full_name,
        email:email,
        first_name:first_name,
        last_name:last_name,
        image:"https://lh3.googleusercontent.com/blabla/photo.jpg"
      },
      credentials:{
        token:"ya29.AHES6ZT5hexqVMS15XnzR_eKwsEnrwklihgrourweghfkauef",
        refresh_token:"1/-wufaliwuegfluawghelfigu-msAYBEKZvWsTs",
        expires_at:2351615640,
        expires:true
      },
      extra:{
        raw_info:{
          id:"12345678",
          email:email,
          verified_email:true,
          name:full_name,
          given_name:first_name,
          family_name:last_name,
          link:"https://plus.google.com/12345678",
          picture:"https://lh3.googleusercontent.com/blabla/photo.jpg",
          gender:"male",
          locale:"en-GB"
        }
      }
    })
  end
end