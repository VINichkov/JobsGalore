class ApplyJob extends React.Component{
    constructor(props){
        super(props);
    }

    render(){
        return(
            <div>
                <h3> Are you applying for the following job: <strong><a href={this.props.title.link}>{this.props.title.name}</a></strong></h3>
                <p>
                    <span className="text-success">
                        <span className="glyphicon glyphicon-home"></span>
                        &nbsp;
                        {this.props.company}
                    </span>
                    <span>&nbsp; - &nbsp;</span>
                    <span className="text-warning">
                        {this.props.location.name}
                    </span>
                </p>
                <p><strong> Your application:</strong></p>
                <hr className="colorgraph"/>
                <div className="form-group">
                    <label>Aready a member?</label>
                    <div className="row">
                        <div className="col-xs-6 col-sm-6 col-md-6">
                            <button className="btn btn-success btn-block">Sign in</button>
                        </div>
                        <div className="hidden-xs col-sm-6 col-md-6">
                            <a className="btn btn-linkedin btn-block" href={this.props.linkedin_url}>
                                <i className="i fa fa-linkedin text-left" aria-hidden="true"/>&nbsp;Sign in with linkedIn</a>
                        </div>
                        <div className="col-xs-6 hidden-md hidden-sm hidden-lg">
                            <a className="btn btn-linkedin btn-block" href={this.props.linkedin_url}>
                                <i className="i fa fa-linkedin text-left" aria-hidden="true"/>&nbsp;LinkedIn</a>
                        </div>
                    </div>
                </div>
                <hr className="colorgraph"/>
                <p><strong> Personal information</strong></p>
                <div className='row'>
                    <div className="col-xs-12 col-sm-6 col-md-6">
                        <div className="form-group">
                            <label>*Your first name</label>
                            <input type='text' autoFocus className="form-control" placeholder="First Name" required="required"/>
                        </div>
                    </div>
                    <div className="col-xs-12 col-sm-6 col-md-6">
                        <div className="form-group">
                            <label>*Your surname</label>
                            <input type='text' autoFocus className="form-control" placeholder="Surname" required="required"/>
                        </div>
                    </div>
                </div>
                <div className="form-group">
                    <label>*Your location</label>
                    <br/>
                    <Autocomplete className="form-control dropdown-toggle"
                                  name="client[location"
                                  id= "client_location_id"
                                  route='/search_locations/'
                                  defaultName= {this.props.location.name}
                                  defaultId={this.props.location.id} />
                </div>
                <div className="form-group">
                    <label>*Your phone number</label>
                    <input type='tel' autoFocus className="form-control" placeholder="+61 9 9999 99999" required="required"/>
                </div>
                <div className="form-group">
                    <label>*Password</label>
                    (6 characters minimum)
                    <br/>
                    <input type='password'  autoComplete="off" className="form-control" placeholder="**************" required="required"/>
                </div>
                <div className="row">
                    <div className="form-group">
                            <div className="col-xs-6 col-sm-6 col-md-6">
                                <button className="btn btn-primary btn-block">Continue</button>
                            </div>
                    </div>
                </div>
                <hr className="colorgraph"/>
            </div>
        );
    }
}