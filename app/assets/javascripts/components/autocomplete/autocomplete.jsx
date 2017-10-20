
class Autocomplete extends React.Component{
    constructor(props) {
        super(props);
        let text = "";
        let possible = "abcdefghijklmnopqrstuvwxyz";

        for( var i=0; i < 5; i++ )
            text += possible.charAt(Math.floor(Math.random() * possible.length));

        this.state = {  display:'none',
                        autocomplete: null,
                        locations: null,
                        id:text};
        this.handleInput = this.handleInput.bind(this);
        this.handleBlur = this.handleBlur.bind(this);
        this.handleClickItem =  this.handleClickItem.bind(this);
    }


    handleInput(){
        if (this.state.autocomplete == null){
            this.setState({autocomplete: document.querySelector('#' + this.state.id)});
            document.querySelector('#input_get'+this.state.id).value = '';
        }
        if (this.state.autocomplete.value.length>0) {
            if (this.state.display == 'none') {
                this.setState({display: "block"});
            }
            this.handleSearchLocations("/search_locations/"+this.state.autocomplete.value+".json");
            document.querySelector('#input_get'+this.state.id).value = '';
        } else {
            this.setState({display: "none"});
        }
    }
    handleBlur(e){
        if (this.state.display == 'block') {
            this.setState({display: "none"});
        }
    }
    handleSearchLocations(url){
        $.ajax({url:url,
            success: function (data) {
                this.setState({locations:data});
            }.bind(this)});
    }
    handleClickItem(e) {
        if (e.target.id.indexOf('location_li'+this.state.id) !== -1) {
            document.querySelector('#input_get'+this.state.id).value = e.target.dataset.id;
            this.state.autocomplete.value = e.target.text;
        }
    }
    render(){
        var ulStyle={display:this.state.display};
        var ilStyle={display:'none'};
        if ( this.state.locations !== null ) {
            var locations = this.state.locations.map(function(location) {
                return(<li key={location.id} >
                            <a id={'location_li'+this.state.id+location.id} data-id = {location.id} href="#" onClick={this.handleClickItem}>
                                {location.suburb}, {location.state}
                            </a>
                        </li>);
            }.bind(this));
        }
        return(
            <div className="dropdown" onMouseDown={this.handleClickItem}>
                <input name={this.props.name + "_name]"} autocomplete = off className={this.props.className} onInput={this.handleInput} onBlur={this.handleBlur} defaultValue = {this.props.defaultName} placeholder={this.props.place_holder} type="text"  id={this.state.id} style={this.props.style}></input>
                <input id={"input_get"+this.state.id} name={this.props.name + "_id]"} defaultValue = {this.props.defaultId} style={ilStyle}/>
                <ul className="dropdown-menu" style={ulStyle}>
                    {locations}
                </ul>
            </div>
        );
    }
}