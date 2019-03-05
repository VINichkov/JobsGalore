class Autocomplete extends React.Component{
    constructor(props) {
        super(props);
        this.state = {  display:'none',
                        autocomplete: null,
                        input_id:null,
                        locations: null,
                        defaultId: this.props.defaultId,
                        defaultName: this.props.defaultName,
                        input: !this.props.not_id };
        this.value_to_array = function (arg) {
            if (arg !== null){
                return arg.map(function (e) {
                    return e.name;
                })
            } else{
                return null;
            }
        };
        this.handleInput = this.handleInput.bind(this);
    }
    componentDidMount(){
        let input = $('#' + this.props.id).first();
        if (input !=null) {
            input.typeahead({
                hint: true,
                highlight: true,
                minLength: 1,
                source:  '', //["rub", "rubber", "rubbing", "rubbish", "ruby", "rudder", "rude", "rudimentary", "rueful", "ruffle" ],
            });
            this.setState({autocomplete: input});
        }
        if (this.state.input) {
            this.setState({input_id: document.querySelector('#input_get' + this.props.id)});
        }
    }
    handleInput(){
        let not_found = true;
        if (this.state.input && this.state.locations !==null){
            for(let i=0; i< this.state.locations.length; i++){
                if (this.state.locations[i].name === this.state.autocomplete.value){
                    this.state.input_id.value =(this.state.locations[i].id);
                    not_found = false;
                    break;
                }
            }
        }
        if (not_found && this.state.autocomplete.val().length>0) {
            this.handleSearchLocations(this.props.route+this.state.autocomplete.val()+".json");
        }

    }

    handleSearchLocations(url){
        $.ajax({url:url,
            success: function (data) {
                this.setState({locations:data});
                if (this.state.autocomplete !==null && this.state.locations !== null)  {
                    this.state.autocomplete.data('typeahead').source = this.state.locations;
                }
            }.bind(this)});
    }

    render(){
        const ilStyle={display:'none'};
        let input_id = null;
        if (this.state.input) {
            input_id = <input ref={this.props.idRef} key={this.props.name + "_id]"} id={"input_get"+this.props.id} name={this.props.name + "_id]"} defaultValue = {this.state.defaultId} className={this.props.className+" typeahead"} style = {ilStyle}/>;
        }
        return(
            <div>
                <input   ref={this.props.nameRef} key = {this.state.input ? this.props.name + "_name]" : this.props.name} name={this.state.input ? this.props.name + "_name]" : this.props.name} autoComplete = "off" className={this.props.className} onInput={this.handleInput}  defaultValue = {this.state.defaultName} placeholder={this.props.place_holder} type="text"  id={this.props.id} style={this.props.style}/>
                {input_id}

            </div>
        );
    }
}