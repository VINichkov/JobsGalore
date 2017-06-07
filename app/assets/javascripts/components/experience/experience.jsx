class Experience extends React.Component{
    constructor(props) {
        super(props);
        let mass=[];
        mass.push(null);
        this.state = { index:this.props.default ? this.props.default : mass,
                        stat:true};
        this.handleOnClick=this.handleOnClick.bind(this);
        this.handleOnDel = this.handleOnDel.bind(this);
    }
    handleOnClick(){
        if (this.state.index.length < 15) {
            let mass = this.state.index;
            mass.push(null);
            this.setState({index: mass});
        }
    }
    handleOnDel(key){
            let mass = this.state.index;
            mass.splice(Number(key.target.id),1);
            this.setState({index: mass,
                            stat:false});
    }

    componentDidUpdate(){
        $('.datepicker_reg').datepicker({
            orientation: "bottom auto",
            language: "en-AU",
            autoclose: true
        });
    }
    render() {
        var elem = null;
        if (this.state.stat) {
            elem = this.state.index.map(function (currentValue, index) {
                return (<div className="well" id={index}>
                    <div className="row" key={index}>
                        <div className="col-md-10 col-lg-10" key={index}>
                            <div className="form-group" key={index}>
                                <label> Position </label>
                                <br />
                                <input className="form-control" type="text"
                                       name={this.props.name + "[bloc_" + index + "]" + "position"}
                                       defaultValue={currentValue ? currentValue.titlejob : ""}/>
                            </div>
                        </div>
                        <div className="col-md-2 col-lg-2">
                            <a id={index} className="btn btn-danger btn-block  btn-lg" data-confirm="Are you sure?"
                               onClick={this.handleOnDel}>Delete</a>
                        </div>
                    </div>
                    <div className="row">
                        <div className="col-md-4 col-lg-4">
                            <div className="form-group">
                                <label> Start of work </label>
                                <br />
                                <div className="input-group date datepicker_reg">
                                    <input className="form-control" type="text"
                                           name={this.props.name + "[bloc_" + index + "]" + "datestart"}
                                           defaultValue={currentValue ? currentValue.datestart : ""}/>
                                    <span className="input-group-addon">
                                                <i className="glyphicon glyphicon-calendar"/>
                                            </span>
                                </div>
                            </div>
                        </div>
                        <div className="col-md-4 col-lg-4">
                            <div className="form-group">
                                <label> End </label>
                                <br />
                                <div className="input-group date datepicker_reg">
                                    <input className="form-control" type="text"
                                           name={this.props.name + "[bloc_" + index + "]" + "dateend"}
                                           defaultValue={currentValue ? currentValue.dateend : ""}/>
                                    <span className="input-group-addon">
                                                <i className="glyphicon glyphicon-calendar"/>
                                            </span>
                                </div>
                            </div>
                        </div>
                        <div className="col-md-2 col-lg-2">
                            <div className="form-group">
                                <label> Location </label>
                                <br />
                                <Autocomplete className="form-controldropdown-toggle"
                                              defaultName={currentValue ? currentValue.location_name : this.props.defaultEmptyLocations.name}
                                              defaultId={currentValue ? currentValue.location_id : this.props.defaultEmptyLocations.id}
                                              name={this.props.name + "[bloc_" + index + "]" + "[location"}
                                              id={"location_bloc_" + index}
                                              key={index}/>
                            </div>
                        </div>
                    </div>

                    <div className="row">
                        <div className="col-md-6 col-lg-6">
                            <div className="form-group">
                                <label> Organization </label>
                                <br />
                                <input className="form-control" type="text"
                                       name={this.props.name + "[bloc_" + index + "]" + "employer"}
                                           defaultValue={currentValue ? currentValue.employer : ""}/>
                            </div>
                        </div>
                        <div className="col-md-6 col-lg-6">
                            <div className="form-group">
                                <label> Site </label>
                                <br />
                                <input className="form-control" type="text"
                                       name={this.props.name + "[bloc_" + index + "]" + "site" }
                                       defaultValue={currentValue ? currentValue.site : ""}/>
                            </div>
                        </div>
                    </div>
                    <div className="form-group">
                        <label> Responsibilities, tasks, achievements </label>
                        <br />
                        <textarea
                            className="form-control" data-provide="markdown-editable" rows="10" type="text"
                            name={this.props.name + "[bloc_" + index + "]" + "description"}
                            defaultValue={currentValue ? currentValue.description : ""} key={index}/>
                    </div>
                </div>);
            }.bind(this));
        } else{
            elem = <div> </div>
            this.setState({stat:true});
        }

        return (<div>
                    {elem}
                    <div className="row">
                        <div className="col-md-6 col-lg-6 col-md-offset-6 col-lg-offset-6">
                            <a className="btn btn-success btn-block" onClick={this.handleOnClick}>Add experience</a>
                        </div>
                    </div>
                </div>);
    }
}