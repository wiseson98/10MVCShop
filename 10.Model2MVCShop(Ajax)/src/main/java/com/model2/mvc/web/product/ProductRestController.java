package com.model2.mvc.web.product;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;

//==> ªÛ«∞ RestController
@RestController
@RequestMapping("/product/*")
public class ProductRestController {

	/// Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	@Resource(name="uploadPath")
	String uploadPath;
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
		   
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	public ProductRestController() {
		System.out.println(this.getClass());
	}
	
	@RequestMapping(value = "json/addProduct", method = RequestMethod.POST)
	public Product addProduct(@RequestBody Product product, MultipartFile file) throws Exception{
		
		System.out.println("/product/json/addProduct : POST");
		System.out.println("Product : " + product.getProdName());
		
		if(file != null && !file.isEmpty()) {
			String savedName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
			
			FileCopyUtils.copy(file.getBytes(), new File(uploadPath, savedName));
					
			product.setFileName(savedName);
		}else {
			System.out.println("else");
		}
		
		productService.addProduct(product);
		
		System.out.println("addProduct");
		return product;
	}	
	
	@RequestMapping(value = "json/getProduct/{prodNo}", method = RequestMethod.GET)
	public Product getProduct(@PathVariable int prodNo) throws Exception{
		
		System.out.println("product/json/getProduct : GET");
		
		return productService.getProduct(prodNo);
	}
	
	@RequestMapping(value = "json/updateProduct", method = RequestMethod.POST)
	public Product updateProduct(@RequestBody Product product) throws Exception{
		
		System.out.println("product/json/updateProduct : POST");
		
		productService.updateProduct(product);
		
		return productService.getProduct(product.getProdNo());
	}
	
	@RequestMapping(value = "json/listProduct/{menu}")
	public Map<String, Object> listProduct(@PathVariable String menu, @RequestBody Search search) throws Exception{
		
		System.out.println("/product/json/listProduct");
		
		if(search.getCurrentPage() == 0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		Map<String, Object> map = productService.getProductList(search);
		
		Page resultPage	= new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		map.put("resultPage", resultPage);
		map.put("menu", menu);
		map.put("search", search);
		
		return map;
	}
	
	@RequestMapping(value = "json/productNameList/{keyword}")
	public List<String> productNameList(@PathVariable String keyword) throws Exception{
		
		System.out.println("/product/json/productNameList");
		System.out.println("keyword : " + keyword);
		
		List<String> productNames = productService.getProductNameList(keyword);
		System.out.println("productNames : " + productNames);
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("productNames", productNames);
		
		return productNames;
	}
}
