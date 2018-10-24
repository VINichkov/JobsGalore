class NewResume extends React.Component{
    constructor(props){
        super(props);
        this.state = {
            text: this.props.text,
            title:null,
            industry:null,
            location_name:this.props.location.name,
            location_id:this.props.location.id};
        this._divEditable = React.createRef();

        this._fileInput = React.createRef();
        this.handleOnClickResume =  this.handleOnClickResume.bind(this);
        this.readURL = this.readURL.bind(this);
        this.handleLinkedIn = this.handleLinkedIn.bind(this);
    }


    componentDidUpdate() {
        let dom = ReactDOM.findDOMNode(this._divEditable.current);
        this.medium = new MediumEditor(dom, this.props.options);
        this.medium.subscribe('editableInput', (e) => {
            this._updated = true;
            this.change(dom.innerHTML);
        });
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

    handleOnClickResume(){
        this.props.onchange('new_resume');
    }

    readURL() {
        let input = this._fileInput.current;
        let uploadTXT = function(uploadFile) {
            let reader = new FileReader();
            reader.onload = function (e) {
                let html = e.target.result;
                html = html.replace(new RegExp('<','g'), "&lt;");
                html = html.replace(new RegExp('>','g'), "&gt;");
                this.medium.setContent(html,0);
                //this._divEditable.current.innerHTML = html;
            }.bind(this);
            reader.readAsText(uploadFile);
        }.bind(this);

        let uploadPdfDocx = function(uploadFile) {
            let fd = new FormData;
            fd.append('file', uploadFile);
            $.ajax({
                type: 'POST',
                url: this.props.url_for_parse,
                data: fd,
                success: function( data ) {
                    this.medium.setContent(data.description,0);
                }.bind(this),
                contentType: false,
                processData: false
            });
        }.bind(this);

        if (input.files) {
            let uploadFile = input.files[0];
            switch(uploadFile.type){
                case 'text/plain':
                    uploadTXT(uploadFile);
                    break;
                default:
                    uploadPdfDocx(uploadFile);
            }
        }
    }

    handleLinkedIn(){
        console.log("You clicked to 'Resume from LinkedIn'");
        $.get(this.props.linkedin_resume_url, function(data) {
            console.log("We get title:"+data.title+" industry:"+ data.industry_id+" location_id:"+data.location_id+" location_name:"+data.location_name+" description:"+data.description);
            this.setState({ title:data.title,
                            industry:{id:data.industry_id},
                            location_id:data.location_id,
                            location_name:data.location_name});
            this.medium.setContent(data.description,0);
        }.bind(this));
        console.log("Well done!");
    }

    render(){
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
                    <input type="text" defaultValue={this.state.title} name="resume[title]" className="form-control" required="required" />
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
                                          defaultName = {this.state.location_name}
                                          defaultId = {this.state.location_id}/>
                        </div>
                    </div>
                </div>
                <div className="form-group">
                    <label>Professional area</label>
                    <br/>
                    <Category style={{width:'100%'}} defaultValue={this.props.industry} className="form-control navbar-btn" name="resume[category]" categories = {this.props.categories}/>
                </div>
                <div className="form-group">
                    <label>Resume (CV)</label>
                    <br/>
                    <textarea name="resume[description]"  className="markdown none" id="resume_description"></textarea>
                    <div className="editable" ref={this._divEditable}></div>
                </div>
                <div className="form-group">
                    <input ref={this._fileInput} type="file" id='inp' accept=".txt, .docx, .pdf" onChange={this.readURL}/>
                    <h5><small>We accept.TXT .DOCX .PDF</small></h5>
                </div>
            </div>;
        }
        return(
            <div>
                <div className="panel panel-info" >
                    <div className="panel-heading " onClick={this.handleOnClickResume} >
                        <input type="radio" id="new_resume_head" name="resume" value="New resume" checked={this.props.check}/> New resume
                    </div>
                    {field_new_resume}
                </div>
            </div>
        );
    }

    change(text) {
        if (this.props.onChange) this.props.onChange(text, this.medium);
    }
}