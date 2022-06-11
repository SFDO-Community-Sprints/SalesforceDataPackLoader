public class LoadSnowfakeryJSONData {
    @InvocableMethod(label='Load Snowfakery Data Bundle'
        description='Load a Snowfakery data bundle file into an Org by URL (JSON Graph API format)')
    public static void loadJsonSet(List<String> json_url){
        for(String url: json_url){
            LoadCompositeAPIData.loadJsonSet(url);
        }
    }
}