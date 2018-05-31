
class Autocomplete extends React.Component{
    constructor(props) {
        super(props);
        this.state = {  display:'none',
                        autocomplete: null,
                        input_id:null,
                        locations: null,
                        input:this.props.not_id ? false : true };
        this.handleInput = this.handleInput.bind(this);
    }
    componentDidMount(){
        this.setState({autocomplete: document.querySelector('#' + this.props.id)});
        if (this.state.input) {
            this.setState({input_id: document.querySelector('#input_get' + this.props.id)});
        }
    }
    handleInput(){
        let not_found = true;
        if (this.state.input && this.state.locations !==null){
            for(var i=0; i< this.state.locations.length; i++){
                if (this.state.locations[i].name ==this.state.autocomplete.value){
                    this.state.input_id.value =(this.state.locations[i].id);
                    not_found = false;
                    break;
                }
            }
        }
        if (not_found && this.state.autocomplete.value.length>0) {
            this.handleSearchLocations(this.props.route+this.state.autocomplete.value+".json");
        }

    }

    handleSearchLocations(url){
        $.ajax({url:url,
            success: function (data) {
                this.setState({locations:data});
            }.bind(this)});
    }

    render(){
        const ilStyle={display:'none'};
        if ( this.state.locations !== null ) {
            var locations = this.state.locations.map(function(location) {
                return(
                            <option key={'location_li'+this.state.id+location.id} data-id = {location.id}>
                                {location.name}
                            </option>);
            }.bind(this));
        }
        let input_id = null;
        if (this.state.input) {
            input_id = <input list={this.props.name} id={"input_get"+this.props.id} name={this.props.name + "_id]"} defaultValue = {this.props.defaultId} className={this.props.className} style = {ilStyle}/>;
        }
        return(
            <div>
                <input itemprop="query-input" list={this.props.name} name={this.state.input ? this.props.name + "_name]" : this.props.name} autoComplete = "off" className={this.props.className} onInput={this.handleInput}  defaultValue = {this.props.defaultName} placeholder={this.props.place_holder} type="text"  id={this.props.id} style={this.props.style} required></input>
                {input_id}
                <datalist id={this.props.name}>
                    {locations}
                </datalist>
            </div>
        );
    }
}