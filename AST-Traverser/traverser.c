#include <stdio.h>
#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "tm.h"
#include "tree.h"
#include "cgraph.h"
#include "hashtab.h"
#include "langhooks.h"
#include "tree-iterator.h"

int num_func;
int num_global_var;
int num_local_var;
int num_statements;

void process_stmt (tree stmt) {
	tree_stmt_iterator si;
	switch (TREE_CODE(stmt)) {
		case STATEMENT_LIST: // this is a statement list
			printf("statement_list\n");
			for (si = tsi_start (stmt); !tsi_end_p (si); tsi_next (&si)) {
				process_stmt(tsi_stmt(si));
			}
			break;
		case BIND_EXPR: // this is a bind expression
			printf("bind_expr\n");
			process_stmt((BIND_EXPR_BODY(stmt)));
			break;
		case DECL_EXPR: // this is a desclare expression
			printf("decl_expr\n");
			num_statements++;
			num_local_var++;
			break;
		case MODIFY_EXPR: // this is a modify expression
			printf("modify_expr\n");
			num_statements++;
			break;
		case CALL_EXPR: // this is a function call expression
			printf("call_expr\n");
			num_statements++;
			break;
		case RETURN_EXPR: // this is a return value expression
			printf("return_expr\n");
			num_statements++;
			break;
		case COND_EXPR: // this is a conditional branch expression
			printf("cond_expr\n");
			tree then_node = COND_EXPR_THEN(stmt);
			tree else_node = COND_EXPR_ELSE(stmt);
			
			if (!(then_node && TREE_CODE(then_node) == GOTO_EXPR && !EXPR_HAS_LOCATION(then_node)
				&& else_node && TREE_CODE(else_node) == GOTO_EXPR && !EXPR_HAS_LOCATION(else_node))) {
				num_statements++;
			}
			process_stmt(COND_EXPR_THEN(stmt));
			if (COND_EXPR_ELSE(stmt))
				process_stmt(COND_EXPR_ELSE(stmt));
			break;
		case SWITCH_EXPR: // this is a switch branch expression
			printf("switch_expr\n");
			num_statements++;
			process_stmt(SWITCH_BODY(stmt));
			break;
		case CASE_LABEL_EXPR: // this is a case label expression
			printf("case_label_expr\n");
			break;
		case GOTO_EXPR: // this is a jump expression
			printf("goto_expr\n");
			// if (!DECL_IS_BUILTIN(GOTO_DESTINATION (stmt)))
					// num_statements++;
			
			if (EXPR_HAS_LOCATION(stmt)) {
				num_statements++;
			}
			
			break;
		case LABEL_EXPR: // this is a jump destination label expression
			printf("label_expr\n");
			break;
			
		default:
			printf("default\n");
			break;
	}
	// printf("number of statements: %d\n", num_statements);
}

void cs502_proj1()
{
	num_func = 0;
	num_global_var = 0;
	num_local_var = 0;
	num_statements = 0;
	
	printf("please implenment your analyzer of project here\n");
	
	// count global variables
	struct varpool_node *var_node;
	tree global_decl;
	for (var_node = varpool_nodes; var_node; var_node = var_node->next) {
		global_decl = var_node->decl;
		num_global_var++;
	}
	
	// deal with functions
	struct cgraph_node *func_node;
	tree fn;
	for (func_node = cgraph_nodes; func_node; func_node = func_node->next) {
		fn = func_node->decl; //get a function
		if (TREE_CODE(fn) == FUNCTION_DECL) {
			printf("\nfunction name: %s\n", IDENTIFIER_POINTER(DECL_NAME(fn)));
			
			process_stmt(BIND_EXPR_BODY(DECL_SAVED_TREE(fn)));
		}
		num_func++;
	}
	
	printf("\nnumber of functions: %d\n", num_func);
	printf("number of global variables: %d\n", num_global_var);
	printf("number of local variables: %d\n", num_local_var);
	printf("number of statements: %d\n", num_statements);

  FILE *fp = fopen("./output.txt", "w");
	fprintf(fp, "#functions: %d\n", num_func);
	fprintf(fp, "#global vars: %d\n", num_global_var);
	fprintf(fp, "#local vars: %d\n", num_local_var);
	fprintf(fp, "#statements: %d\n", num_statements);
	fclose(fp);
}
