

import 'package:sel_it/models/product_model.dart';

class Repository{

  Future<void> publishProduct({required ProductModel productModel})async{
    print("ProductModel -> ${productModel.title}");
    try {
     await Future.delayed(Duration(seconds: 5));
    }catch(e){
      throw e;
    }

  }

}