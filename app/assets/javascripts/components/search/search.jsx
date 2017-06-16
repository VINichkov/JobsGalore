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
        if (this.state.type_search_code ===null){
            if ((this.props.params ? this.props.params.type: null) == null){
                this.setState({ type_search_code:this.state.list_type[2].code,
                                type_search_name:this.state.list_type[2].name});
            } else{
                this.setState({ type_search_code:this.state.list_type[Number(this.props.params.type)].code,
                                type_search_name:this.state.list_type[Number(this.props.params.type)].name});
            }
        }
        let options = null;
        let button_option = 'btn-info';
        if (this.state.active_options) {
            if (this.state.type_search_code == 2 || this.state.type_search_code == 3){
                options =   [<div className="row">
                                <div className="form-group" style={{display:'inline'}}>
                                    <div className="col-md-2 col-lg-2">
                                        <label style={{width:'100%'}} className="navbar-text ">Select category</label>
                                    </div>
                                    <div className="col-md-10 col-lg-10">
                                        <Category style={{width:'100%'}} defaultValue={this.props.params ? this.props.params.category: ''} name={this.props.name+'[category]'} categories = {this.props.categories} id="category_search" className="form-control navbar-btn"/>
                                    </div>
                                </div>
                            </div>,
                            <div className="row">
                                <div className="form-group" style={{display:'inline'}}>
                                    <div className="col-md-2 col-lg-2">
                                        <label style={{width:'100%'}} className="navbar-text">Location</label>
                                    </div>
                                    <div className="col-md-10 col-lg-10">
                                        <Autocomplete style={{width:'100%'}} className="form-control dropdown-toggle" defaultId={this.props.params ? this.props.params.location_id:''} defaultName={this.props.params ? this.props.params.location_name:''} name={this.props.name+'[location'} id="location_search" />
                                    </div>
                                </div>
                            </div>,
                            <div className="row">
                                <div className="form-group" style={{display:'inline'}}>
                                    <div className="col-md-2 col-lg-2">
                                        <label style={{width:'100%'}} className="navbar-text">Salary</label>
                                    </div>
                                    <div className="col-md-10 col-lg-10">
                                        <input style={{width:'100%'}} id="salary" className="form-control" defaultValue={this.props.params ? this.props.params.salary: ''} name={this.props.name+'[salary]'} pattern="^[ 0-9]+$" type="text"/>
                                    </div>
                                </div>
                            </div>,
                            <div className="row">
                                <div className="form-group">
                                    <div className="checkbox col-md-3 col-lg-3">
                                        <label className="navbar-text"><input type="checkbox" defaultChecked={this.props.params ? this.props.params.permanent:false} name={this.props.name+'[permanent]'}/> Permanent</label>
                                    </div>
                                    <div className="checkbox col-md-3 col-lg-3">
                                        <label className="navbar-text"><input type="checkbox" defaultChecked={this.props.params ? this.props.params.casual:false} name={this.props.name+'[casual]'}/> Casualt</label>
                                    </div>
                                    <div className="checkbox col-md-3 col-lg-3">
                                        <label className="navbar-text"><input type="checkbox" defaultChecked={this.props.params ? this.props.params.temp:false} name={this.props.name+'[temp]'}/> Temporary</label>
                                    </div>
                                    <div className="checkbox col-md-3 col-lg-3">
                                        <label className="navbar-text"><input type="checkbox" defaultChecked={this.props.params ? this.props.params.contract:false} name={this.props.name+'[contract]'}/> Contract</label>
                                    </div>
                                    <div className="checkbox col-md-3 col-lg-3">
                                        <label className="navbar-text"><input type="checkbox" defaultChecked={this.props.params ? this.props.params.fulltime:false} name={this.props.name+'[fulltime]'}/> Full-time</label>
                                    </div>
                                    <div className="checkbox col-md-3 col-lg-3">
                                        <label className="navbar-text"><input type="checkbox" defaultChecked={this.props.params ? this.props.params.parttime:false} name={this.props.name+'[parttime]'}/> Part-time</label>
                                    </div>
                                    <div className="checkbox col-md-3 col-lg-3">
                                        <label className="navbar-text"><input type="checkbox" defaultChecked={this.props.params ? this.props.params.flextime:false} name={this.props.name+'[flextime]'}/> Flex-time</label>
                                    </div>
                                    <div className="checkbox col-md-3 col-lg-3">
                                        <label className="navbar-text"><input type="checkbox" defaultChecked={this.props.params ? this.props.params.remote:false} name={this.props.name+'[remote]'}/> Remote</label>
                                    </div>
                                    <div style={{display:'none'}}>
                                        <input type="checkbox" checked="checked" name={this.props.name+'[options]'}/>
                                    </div>
                                </div>
                            </div>];

            } else if (this.state.type_search_code == 1){
                button_option = 'btn-primary';
                this.setState({active_options:false});
            }
        } else {
            button_option = 'btn-primary';
        };

        return(<div>
                    <div className="form-group  " style={{display:'inline'}}>
                            <div className="input-group" style={{display:'table'}}>
                                <div className="input-group-btn" style={{width:'1%'}}>
                                    <button className={"btn input-lg "+button_option} onClick={this.handleOnClickOptions} data-toggle = "popover-options" type="button">
                                        <i className="glyphicon glyphicon-cog glyphicon-big"></i>
                                    </button>
                                    <button className="btn btn-default dropdown-toggle input-lg" type="button" data-toggle="dropdown" aria-haspopup="true">
                                        {this.state.type_search_name}
                                        <span className="caret"></span>
                                    </button>
                                    <ul className="dropdown-menu">
                                        <li><a id="Search_1" data-id = '2'  onClick={this.handleClickItem}>Jobs &nbsp;</a></li>
                                        <li><a id="Search_2" data-id = '3'  onClick={this.handleClickItem}>Resumes &nbsp;</a></li>
                                        <li><a id="Search_3" data-id = '1'  onClick={this.handleClickItem}>Companies &nbsp;</a></li>
                                    </ul>
                                </div>

                                <input id="input_search" name={this.props.name+'[type]'}  value={this.state.type_search_code} style={ilStyle}></input>
                                <input id="input_search_value" className="form-control input-lg" placeholder="Search"  defaultValue={this.props.params ? this.props.params.value : ''} name={this.props.name+'[value]'}  type="text"></input>
                                <div className="input-group-btn" style={{width:'1%'}}>
                                             <button className="btn btn-success input-lg" type="submit">
                                                 <i className="glyphicon glyphicon-search glyphicon-big"></i>
                                             </button>
                                </div>
                            </div>
                    </div>
                    {options}
                </div>
        );
    }
}