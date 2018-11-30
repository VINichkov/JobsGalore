class Search extends React.Component{
    constructor(props){
    super(props);
        this.state = {  type_search_code:null,
                        type_search_name:null,
                        list_type:{ 1:{code:1, name:"Companies "},
                                    2:{code:2, name:"Jobs "},
                                    3:{code:3, name:"Resumes"}},
                        active_options:false};
        this.handleClickItem =  this.handleClickItem.bind(this);
        this.handleOnClickOptions = this.handleOnClickOptions.bind(this);
    }
    componentWillMount(){
        if (this.state.type_search_code ===null){
            if ((this.props.params ? this.props.params.type: null) == null){
                this.setState({ type_search_code:this.state.list_type[2].code,
                    type_search_name:this.state.list_type[2].name});
            } else{
                this.setState({ type_search_code:this.state.list_type[Number(this.props.params.type)].code,
                    type_search_name:this.state.list_type[Number(this.props.params.type)].name});
            }
        }
    }

    handleClickItem(e) {
        if (e.target.id.indexOf('Search') !== -1) {
            this.setState({ type_search_name: e.target.text,
                            type_search_code: e.target.dataset.id });
        }
    }
    handleOnClickOptions() {
        if (this.state.active_options){
            this.setState({active_options:false});
        } else {
            this.setState({active_options:true});
        }
    }
    render() {
        let ilStyle={display:'none'};
        let options = null;
        let cat = null;
        let button_option = 'btn-info';
        if (this.state.active_options) {
            if (this.state.type_search_code == 3){
                cat = <div className="form-group" style={{display:'inline'}}>
                                <div className="col-md-12 col-lg-12 col-sm-12 col-xs-12">
                                    <Category key="catecory" style={{width:'100%'}} defaultValue={this.props.params ? this.props.params.category: ''} name={this.props.name+'[category]'} categories = {this.props.categories} id="category_search" className="form-control navbar-btn"/>
                                </div>
                            </div>;
            }
            if (this.state.type_search_code == 2 || this.state.type_search_code == 3){
                options =   [<div key="otions_key" className="row">
                                <div className="form-group" style={{display:'inline'}}>
                                    <div className=" col-md-12 col-lg-12 col-sm-12 col-xs-12">
                                        <label>
                                            <input type="checkbox" defaultChecked={this.props.params ? this.props.params.urgent:false} name={this.props.name+'[urgent]'}/>
                                            &nbsp;
                                            <span className="badge badge-error"><strong> &nbsp; Only urgent </strong></span>
                                        </label>
                                    </div>
                                </div>
                                {cat}
                                <div className="form-group" style={{display:'inline'}}>
                                    <div className="col-md-6 col-lg-6 col-sm-12 col-xs-12">
                                        <Autocomplete style={{width:'100%'}} className="form-control dropdown-toggle" route='/search_locations/' defaultId={this.props.params ? this.props.params.location_id:''} defaultName={this.props.params ? this.props.params.location_name:''} name={this.props.name+'[location'} id="location_search"  place_holder="Location"/>
                                        <p />
                                    </div>
                                </div>
                                <div className="form-group" style={{display:'inline'}}>
                                    <div className="col-md-6 col-lg-6 col-sm-12 col-xs-12">
                                        <div  className="input-group" style={{width:'100%'}}>
                                            <span className="input-group-addon" style={{width:'1%'}}>
                                                $
                                            </span>
                                            <InputMask style={{width:'100%'}} dataformat="dddddddddddd"autocomplete="off" id="salary" class_name="form-control" defaultValue={this.props.params ? this.props.params.salary: ''} name={this.props.name+'[salary]'} pattern="^[ 0-9]+$" type="text" placeholder="Salary" not_required={true}/>
                                        </div>
                                    </div>
                                </div>
                            </div>];

            } else if (this.state.type_search_code == 1){
                button_option = 'btn-primary';
                this.handleOnClickOptions();
            }
        } else {
            button_option = 'btn-primary';
        };

        return(<div>
                <div className="form-group  " style={{display: 'inline'}}>
                    <div className="input-group" style={{display: 'table'}}>
                        <div className="input-group-btn hidden-xs" style={{width: '1%'}}>
                            <button className={"btn " + button_option} onClick={this.handleOnClickOptions}
                                    data-toggle="popover-options" type="button">
                                <i className="glyphicon glyphicon-cog glyphicon-big"></i>
                            </button>
                        </div>
                        <input id="input_search" name={this.props.name + '[type]'} value={this.state.type_search_code}
                               style={ilStyle} readOnly={true}></input>


                        <Autocomplete style={{width:'100%'}} className="form-control" route='/dictionary/'
                                      defaultValue={this.props.params ? this.props.params.value : ''}
                                      name={this.props.name + '[value]'} id="input_search_value"
                                      place_holder="Search" not_id={true}/>

                        <div className="input-group-btn" style={{width: '1%'}}>
                            <button className="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown"
                                    aria-haspopup="true">
                                {this.state.type_search_name}
                                <span className="caret"></span>
                            </button>
                            <ul className="dropdown-menu">
                                <li><a id="Search_1" data-id='2' onClick={this.handleClickItem}>Jobs &nbsp;</a></li>
                                <li><a id="Search_2" data-id='3' onClick={this.handleClickItem}>Resumes &nbsp;</a></li>
                                <li><a id="Search_3" data-id='1' onClick={this.handleClickItem}>Companies &nbsp;</a>
                                </li>
                            </ul>
                            <button className="btn btn-success" type="submit">
                                <i className="glyphicon glyphicon-search glyphicon-big"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <p/>
                <div className="form-group hidden-sm hidden-md hidden-lg" style={{display: 'inline'}}>
                    <button className={"btn " + button_option} onClick={this.handleOnClickOptions}
                            data-toggle="popover-options" type="button">
                        Advanced Search &nbsp;
                        <i className="glyphicon glyphicon-cog glyphicon-big"></i>
                    </button>
                </div>
                    {options}
                </div>
        );
    }
}