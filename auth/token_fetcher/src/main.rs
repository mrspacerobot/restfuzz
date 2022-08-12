use std::collections::HashMap;
use serde::{Deserialize};
#[derive(Deserialize)]
struct Response {
    access_token : String,
}
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {

    let client = reqwest::Client::new();

    let mut map = HashMap::new();
    map.insert("client_id","9Q3RGBsZoJME9R3VptTaQVWrsE255XWR");
    map.insert("client_secret","tiSOqVe8nHivPJKK7Z1m7BVyLeverU_w4QO49lNLWteSpmNzvYnQvMiEz8v4buAY");
    map.insert("audience","dm-connectivity");
    map.insert("grant_type","client_credentials");


    let resp_json = client.post("https://siemens-qa-bt-019.eu.auth0.com/oauth/token/")
        .json(&map)
        .send()
        .await?
        .json::<Response>()
        .await?;

    println!("{{u'11111111-11111-1111-1111-1111111': {{}}}}");
    println!("Authorization: Bearer {}",resp_json.access_token); 
    
    Ok(())
}

