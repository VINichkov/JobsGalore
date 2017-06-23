//Форма картинки
//Входной параметр file. Картинка
class Picture extends React.Component{
    constructor(props) {
        super(props);
        this.state = {  patch: null,
                        now_file_nam:'',
                        image: new FileReader,
                        imgStype:{width:'auto',height:'160px'}
        };
        this.handleImageloaded = this.handleImageloaded.bind(this);
        this.parrentModalShow = this.parrentModalShow.bind(this);
        this.state.image.onload = this.handleImageloaded;

    }
    parrentModalShow(){
        this.props.self.modalShow(this.state.patch,this.props.file.name);
    }
    handleImageloaded(e){
        this.setState({patch: e.target.result,
                        e:this.props.file.name});
    }

    render() {
        if (this.state.now_file_nam!=this.props.file.name) {
            this.state.image.readAsDataURL(this.props.file);
            this.setState({now_file_nam:this.props.file.name})
        }
        /*this.setState({photo: this.props.file});*/
        return (
            <div className="file-preview-frame"  onClick={this.parrentModalShow} data-template="image">
                <div className="kv-file-content">
                    <img className="kv-preview-data file-preview-image" src ={this.state.patch}  title ={this.props.file.name}  style={this.state.imgStype}></img>
                </div>
                <div className="file-thumbnail-footer">
                    <div className="file-footer-caption" title={this.props.file.name}>
                        {this.props.file.name}
                        <br />
                        <samp>{Math.round(this.props.file.size/1024*100)/100} кб</samp>
                    </div>
                </div>
            </div>

        );
    }
};




//Входные параметры id={id} className={nameClass} name={name} multiple={multiple}
class Fileinput extends React.Component{
    constructor(props) {
        super(props);
        this.state = {  files: '',
                        preview:'',
                        previw_title:'',
                        class_name: this.props.nameClass,
        };
        this.handleChange = this.handleChange.bind(this);
        this.handleDeleteAll = this.handleDeleteAll.bind(this);
    }
    modalShow(preview,previw_title){
        this.setState({ preview:preview,
                        previw_title:previw_title});
        $("#file_input_preview").modal()
    }

    handleChange(event) {
        var files = [];
        var div = document.querySelector('#' + this.props.id).files;
        for (var i=0; i<div.length; i++){
            if (!div[i].type.match('image.*')) {
                continue;
            }
            files[files.length] = div[i]
        }
        this.setState({files:files});
    }

    handleDeleteAll(){
        document.querySelector('#' + this.props.id).value ='';
        this.setState({files:''});
    }

    render(){
        var photos;
        var index=0;
        if (this.state.files !='') {
            photos = this.state.files.map(function (file) {
                index++;
                return  <Picture key ={index.toString()} file={file} self={this} />;
            });
        }
        var fileCaptionName = function (files) {
            if (files =='' ) {
                return(<div className="file-caption-name" >File not selected</div>);
            } else {
                return(<div className="file-caption-name" title={files[0].name}>{files[0].name}</div>);
            }

        };
        var clear = function(files,method) {
            if (files !='') {
                return (
                    <button className="btn btn-default fileinput-remove fileinput-remove-button"
                            onClick={method} type="button" tabIndex={500}
                            title="Очистить выбранные файлы">
                        <i className="glyphicon glyphicon-trash"/>
                        <span className="hidden-xs">Clear</span>
                    </button>);
            }
        };
        return (
            <div className="file-input">
                {photos}
                <div className={'input-group file-caption-main'}>
                    <div className='form-control file-caption  kv-fileinput-caption '  tabIndex={500}>
                        {fileCaptionName(this.state.files)}
                    </div>
                    <div className='input-group-btn'>
                        {clear(this.state.files, this.handleDeleteAll)}
                        <div className='btn btn-primary btn-file' >
                            <i className="glyphicon glyphicon-folder-open"></i>
                            <span className="hidden-xs"> Selected</span>
                            <input onChange={this.handleChange} id={this.props.id} name={this.props.name}  type="file" accept="image/*,image/jpeg" />
                        </div>
                    </div>
                </div>
                <div id="file_input_preview" className="modal fade">
                    <div className="modal-dialog">
                        <div className="modal-content">
                            <div className="modal-header">
                                <button className="close" type="button" data-dismiss="modal">X</button>
                                <h4 className="modal-title">{this.state.previw_title}</h4>
                            </div>
                            <div className="modal-body">
                                <img src={this.state.preview} className="img-thumbnail"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
};
