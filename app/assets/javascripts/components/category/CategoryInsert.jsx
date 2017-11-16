class CategoryInsert extends React.Component{
    constructor(props) {
        super(props);
        this.state = {options:null};
    }

    render() {
        if (this.state.options == null) {
            let def = true
            let options = JSON.parse(this.props.values).map(function (category) {
                if ((JSON.parse(this.props.defaultValues)!="") && (JSON.parse(this.props.defaultValues)!=null)) {
                    if (JSON.parse(this.props.defaultValues)[0].id ==category.id){
                        return (<option key={category.id} selected value={category.id}>{category.name}</option>);
                    }else {
                        return (<option key={category.id} value={category.id}>{category.name}</option>);
                    }
                } else {
                    if (def) {
                        def = false;
                        return (<option key={category.id} selected value={category.id}>{category.name}</option>);
                    }else {
                        return (<option key={category.id} value={category.id}>{category.name}</option>);
                    }

                }
            }.bind(this));
            this.setState({options:options});
        }
        return (
                <select name={this.props.name} className={this.props.className} multiple={this.props.multiple} data-style={this.props.dataStyle} data-live-search="true">
                    {this.state.options}
                </select>);
    }
}