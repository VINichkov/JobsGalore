class ApplyJob extends React.Component{
    constructor(props){
        super(props);
        let resumes= {new_resume:{checked:false}};
        this.props.resumes.map(function(resume, i){
            resumes["resume_"+i] = {resume: resume, checked:false};
        }.bind(this));
        resumes.resume_0 !== null ? resumes.resume_0.checked = true :  resumes.new_resume.checked = true;
        this.state = {
            resumes: resumes
        };
        this.handleChangeFocus =  this.handleChangeFocus.bind(this);
    }

    handleChangeFocus(e){
        let resumes = this.state.resumes;
        if (!resumes[e].checked){
            Object.keys(resumes).forEach(function (value) {
                resumes[value].checked = false;
            }.bind(this));
            resumes[e].checked = true;
            this.setState({resumes: resumes});
        }
    }

    render(){
        let step;
        if (this.props.resumes == null){
            step = <Autorization title = {this.props.title}
                          company = {this.props.company}
                          location = {this.props.location}
                          sign_in={this.props.sign_in}
                          linkedin_url = {this.props.linkedin_url}
            />;
        } else {
            let old_resume = this.props.resumes.map(function(resume, i){
                return (   <Resume resume = {this.state.resumes["resume_"+i].resume}
                                   onchange = {this.handleChangeFocus}
                                   check = {this.state.resumes["resume_"+i].checked}
                                   key ={i}
                                   keyResume = {i}/> );
            }.bind(this));
            step = <div>
                        <form>
                            <NewResume location = {this.props.location}
                                       check = {this.state.resumes.new_resume.checked}
                                       categories = {this.props.categories}
                                       onchange = {this.handleChangeFocus}
                                       url_for_parse = {this.props.url_for_parse}
                                       user_from_linkedin = {this.props.user_from_linkedin}
                                       linkedin_resume_url ={this.props.linkedin_resume_url}/>
                            <hr/>
                            <p><strong>Resumes:</strong></p>
                            {old_resume}
                        </form>
                    </div>
        }
        return(
            <div>
                {step}
            </div>
        );
    }
}