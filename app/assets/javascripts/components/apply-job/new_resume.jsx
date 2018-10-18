class NewResume extends React.Component{
    constructor(props){
        super(props);
        this.state = {
            text: this.props.text
        };
    }
    componentDidMount() {
        const dom = ReactDOM.findDOMNode(this);

        this.medium = new MediumEditor(dom, this.props.options);
        this.medium.subscribe('editableInput', (e) => {
            this._updated = true;
            this.change(dom.innerHTML);
        });
    }

    componentDidUpdate() {
        this.medium.restoreSelection();
    }

    componentWillUnmount() {
        this.medium.destroy();
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.text !== this.state.text && !this._updated) {
            this.setState({ text: nextProps.text });
        }

        if (this._updated) this._updated = false;
    }

    render(){
        return(
            <div>
                <div className="panel panel-info">
                    <div className="panel-heading">
                        <input type="radio" id="contactChoice" value="New resume" /> New resume
                    </div>
                    <div className="panel-body">
                        <div className="form-group">
                            <label>Title</label>
                            <br/>
                            <input type="text" name="resume[title]" className="form-control" required="required"/>
                        </div>
                        <div className="row">
                            <div className="col-md-6 col-lx-6 col-sm-12 col-xs-12">
                                <div className="form-group">
                                    <label>Desired Salary (Optional)</label>
                                    <br/>
                                    <div className="input-group">
                                        <span className="input-group-addon">$</span>
                                        <input type="text" name="resume[salary]" className="form-control" required="required"/>
                                    </div>
                                </div>
                            </div>
                            <div className="col-md-6 col-lx-6 col-sm-12 col-xs-12">
                                <div className="form-group">
                                    <label>Location</label>
                                    <br/>
                                    <Autocomplete className = "form-control dropdown-toggle"
                                                  name = "resume[location"
                                                  id = "resume_location_id"
                                                  route = "/search_locations/"
                                                  defaultName = {this.props.location.name}
                                                  defaultId = {this.props.location.id}/>
                                </div>
                            </div>
                        </div>
                        <div className="form-group">
                            <label>Professional area</label>
                            <br/>
                            <Category style={{width:'100%'}} className="form-control navbar-btn" name="resume[category]" categories = {this.props.categories}/>
                        </div>
                        <div className="form-group">
                            <label>Resume (CV)</label>
                            <br/>
                            <textarea name="resume[description]" className="markdown none" id="resume_description"></textarea>
                            <div className="editable"></div>
                        </div>
                    </div>
                </div>
            </div>
        );

    }
    change(text) {
        if (this.props.onChange) this.props.onChange(text, this.medium);
    }
}