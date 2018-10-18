class Category extends React.Component{
    constructor(props){
        super(props);
        let data = this.props.categories;
        let flag = true;
        for(var i = 0; i < data.length; i++) {
            if (data[i].id == '') {
                flag = false;
                break;
            }
        }
        if (flag) {
            data.push({id: '', name: "Select category"});
        }
        this.state = {  options:null,
                        categories:data };
    }

    render(){
        let options = this.state.categories.map(function (category) {
            return (<option key={category.id} value={category.id}>{category.name}</option>);
        });
        return(
            <select style={this.props.style} defaultValue={this.props.defaultValue ? this.props.defaultValue.id : ''} className={this.props.className} id = {this.props.id} name = {this.props.name}>
                {options}
            </select>
        );
    }
}