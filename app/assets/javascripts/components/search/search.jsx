class Search extends React.Component{
    constructor(props){
    super(props);
        let type_arr = [{code:1, name:"Companies "},
                        {code:2, name:"Jobs "},
                        {code:3, name:"Resumes"}];
        this.state = {  type_search_code: this.props.search ? type_arr[Number(this.props.search.type)-1].code : null,
                        type_search_name:this.props.search ? type_arr[Number(this.props.search.type)-1].name : null,
                        list_type:type_arr,
                        active_options: this.props.search ? this.props.search.open == 'true' : false,
                        value: this.props.search ? this.props.search.value : '',
                        location_name: this.props.search ? this.props.search.location_name : '',
                        location_id: this.props.search ? this.props.search.location_id : '',
                        salary: this.props.search ? this.props.search.salary : '',
                        urgent: this.props.search ? this.props.search.urgent : false,
                        category: this.props.search ? {id:Number(this.props.search.category)} : ''};
        this.handleClickItem =  this.handleClickItem.bind(this);
        this.handleOnClickOptions = this.handleOnClickOptions.bind(this);
    }
    componentWillMount(){
        if (this.state.type_search_code ===null){
            if ((this.props.params ? this.props.params.type: null) == null){
                this.setState({ type_search_code:this.state.list_type[1].code,
                    type_search_name:this.state.list_type[1].name});
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
        let ilStyle = {display: 'none'};
        let options = null;
        let cat = <div className="form-group" style={{display: 'inline'}}>
            <div className="col-md-12 col-lg-12 col-sm-12 col-xs-12">
                <Category key="category" style={{width: '100%'}}
                          defaultValue={this.state.category}
                          name={this.props.name + '[category]'} categories={this.props.categories}
                          id="category_search" className="form-control navbar-btn"/>
            </div>
        </div>;
        let salary = <div className="col-md-6 col-lg-6 col-sm-12 col-xs-12">
            <div className="input-group" style={{width: '100%'}}>
                                <span className="input-group-addon" style={{width: '1%'}}>
                                    $
                                </span>
                <InputMask style={{width: '100%'}} dataformat="dddddddddddd" autocomplete="off" id="salary"
                           class_name="form-control"
                           defaultValue={this.state.salary}
                           name={this.props.name + '[salary]'} pattern="^[ 0-9]+$" type="text"
                           placeholder="Salary" not_required={true}/>
            </div>
        </div>;
        let urgent = <div className=" col-md-6 col-lg-6 col-sm-12 col-xs-12">
            <label>
                <input type="checkbox" defaultChecked={this.state.urgent}
                       name={this.props.name + '[urgent]'}/>
                &nbsp;
                <span className="badge badge-error"><strong> &nbsp; ONLY URGENT </strong></span>
            </label>
        </div>;
        if (this.state.active_options) {
            if (this.state.type_search_code == 1) {
                options = <div key="otions_key" className="row">
                    {cat}
                </div>;
            } else if (this.state.type_search_code == 2) {
                options = <div key="otions_key" className="row">
                    {salary}
                    {urgent}
                </div>;
            } else if (this.state.type_search_code == 3) {
                options = <div key="otions_key" className="row">
                    {salary}
                    {urgent}
                    {cat}
                </div>;
            }
        }
        return(<div>
                <div className="form-group  " style={{display: 'inline'}}>
                    <div className=" col-md-6 col-lg-6 col-sm-12 col-xs-12">
                        <Autocomplete style={{width: '100%'}} className="form-control" route='/dictionary/'
                                      defaultName={this.state.value}
                                      name={this.props.name + '[value]'} id="input_search_value"
                                      place_holder="What: title, keywords" not_id={true}/>
                    </div>
                    <div className="hidden-md hidden-lg col-sm-12 col-xs-12">
                        <p/>
                    </div>
                    <div className=" col-md-6 col-lg-6 col-sm-12 col-xs-12" style={{display: 'table'}}>
                        <input id="input_action" name={this.props.name + '[open]'} value={this.state.active_options}
                               style={ilStyle} readOnly={true}></input>
                        <input id="input_search" name={this.props.name + '[type]'} value={this.state.type_search_code}
                               style={ilStyle} readOnly={true}></input>
                        <Autocomplete style={{width: '100%'}} className="form-control" route='/search_locations/'
                                      defaultId={this.state.location_id}
                                      defaultName={this.state.location_name}
                                      name={this.props.name + '[location'}
                                      id="location_search" place_holder="Where: city"/>
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
                <div className=" col-md-12 col-lg-12 col-sm-12 col-xs-12">
                    <input className="hide" id="hd-1" type="checkbox" onClick={this.handleOnClickOptions} />
                    <label htmlFor="hd-1" className={this.state.active_options ? "label_checked" : "label_not_checked"}><span>-----</span>&nbsp; Advanced Search &nbsp;<span>-----</span></label>
                        {options}
                </div>
            </div>
        );
    }
}