class NewResume extends React.Component{
    constructor(props){
        super(props);
        this.state = {
            text: this.props.text,
            title:null,
            industry:null,
            location_name:this.props.location.name,
            location_id:this.props.location.id,
            inputDescription:""};
        this._divEditable = React.createRef();
        this._fileInput = React.createRef();
        this.handleOnClickResume =  this.handleOnClickResume.bind(this);
        this.handleLinkedIn = this.handleLinkedIn.bind(this);
    }

    componentDidUpdate() {
        if (this.props.check) {
            tinymce.init(tinyEditorOptions);
        }
    }

    componentWillUnmount() {
        tinymce.remove("textarea#resume_description")
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.text !== this.state.text && !this._updated) {
            this.setState({ text: nextProps.text });
        }
        if (this._updated) this._updated = false;
    }

    handleOnClickResume(){
        this.props.onchange('new_resume');
    }

    handleLinkedIn(){
        $.get(this.props.linkedin_resume_url, function(data) {
            this.setState({ title:data.title,
                            industry: {id: data.industry_id},
                            location_id:data.location_id,
                            location_name:data.location_name,
                            flagVisible: !this.state.flagVisible});
        }.bind(this));
    }

    render(){
        let flag;
        let field_new_resume;
        let buttonLinkedIn;
        if (this.props.user_from_linkedin){
            buttonLinkedIn = <div className="row">
                                <div className="form-group">
                                    <div className="hidden-xs col-md-6 col-sm-6 col-lg-6">
                                        <a className="btn btn-linkedin btn-bloc" onClick={this.handleLinkedIn}>
                                            <i className="fa fa-linkedin text-left" aria-hidden="true"/>
                                            &nbsp;|&nbsp;Resume from LinkedIn
                                        </a>
                                    </div>
                                    <div className="col-xs-6 hidden-md hidden-sm hidden-lg">
                                        <a className="btn btn-linkedin btn-bloc" onClick={this.handleLinkedIn}>
                                            <i className="fa fa-linkedin text-left" aria-hidden="true"/>
                                            &nbsp;|&nbsp;Resume
                                        </a>
                                    </div>
                                </div>
                            </div>
        }
        if (this.props.check){
            field_new_resume =  <div className="panel-body">
                {buttonLinkedIn}
                <br/>
                <div className="form-group">
                    <label>Title</label>
                    <br/>
                    <input type="text" defaultValue={this.state.title} name={this.props.name+"[title]"} className="form-control" required="required" />
                </div>
                <div className="row">
                    <div className="col-md-6 col-lx-6 col-sm-12 col-xs-12">
                        <div className="form-group">
                            <label>Desired Salary (Optional)</label>
                            <br/>
                            <div className="input-group">
                                <span className="input-group-addon">$</span>
                                <input type="text" name={this.props.name+"[salary]"} className="form-control"/>
                            </div>
                        </div>
                    </div>
                    <div className="col-md-6 col-lx-6 col-sm-12 col-xs-12">
                        <div className="form-group">
                            <label>Location</label>
                            <br/>
                            <Autocomplete className = "form-control dropdown-toggle"
                                          name = {this.props.name+"[location"}
                                          id = "resume_location_id"
                                          route = "/search_locations/"
                                          defaultName = {this.state.location_name}
                                          defaultId = {this.state.location_id}/>
                        </div>
                    </div>
                </div>
                <div className="form-group">
                    <label>Professional area </label>
                    <br/>
                    <Category style={{width:'100%'}}  key = {this.state.flagVisible} defaultValue={this.state.industry} className="form-control navbar-btn" name={this.props.name+"[category]"} categories = {this.props.categories}/>
                </div>
                <div className="form-group">
                    <label>Resume (CV)</label>
                    <br/>
                    <textarea name={this.props.name+"[description]"} className="tinymce"  rows="20"  id="resume_description"></textarea>

                </div>

            </div>;
        }else{
            tinymce.remove("textarea#resume_description");
        }
        return(
            <div>
                <div className="panel panel-info" >
                    <div className="panel-heading " onClick={this.handleOnClickResume} >
                        <input type="radio" id="new_resume_head" name={this.props.nameCheckbox} value="New resume" checked={this.props.check}/> New resume
                    </div>
                    {field_new_resume}
                </div>
            </div>
        );
    }
}