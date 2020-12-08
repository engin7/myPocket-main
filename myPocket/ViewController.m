//
//  ViewController.m
//  My Pocket
//
//  Created by Engin KUK on 30.11.2020.
//

#import "ViewController.h"
#import "ListTableViewCell.h"
#import "AddItemViewController.h"
#import "AddIncomeViewController.h"
#import "FMDB.h"
#import "myPocket-Swift.h" // to access Swift files with @objc prefix


@interface ViewController () <UITableViewDataSource,UITableViewDelegate, AddItemViewControllerDelegate, AddIncomeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Net Balance in $ %li",  (long)self.balance];
    
    self.EntryID = DBManager.shared.field_EntryID;
    self.EntryTitle = DBManager.shared.field_EntryTitle;
    self.EntryType = DBManager.shared.field_EntryType;
    self.EntryAmount = DBManager.shared.field_EntryAmount;
    self.entries = [[NSMutableArray<Entry *> alloc] init];
    self.entries = [[DBManager.shared loadEntries] mutableCopy];
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ListTableViewCell";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *expenseText =@"";
    
    if (self.entries[indexPath.row].type) {
        expenseText = [NSString stringWithFormat:@"income: %@   value: $%ld", self.entries[indexPath.row].title, (long)self.entries[indexPath.row].amount];
        self.balance += self.entries[indexPath.row].amount;
        cell.backgroundColor = [UIColor greenColor];
    } else {
        expenseText = [NSString stringWithFormat:@"expense: %@   value: $%ld",  self.entries[indexPath.row].title, (long)self.entries[indexPath.row].amount];
        self.balance -= self.entries[indexPath.row].amount;
        cell.backgroundColor = [UIColor orangeColor];
    }
        
    cell.titleLabel.text = expenseText;
    self.title = [NSString stringWithFormat:@"Net Balance in $ %li",  (long)self.balance];

    return cell;
 }

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        self.title = [NSString stringWithFormat:@"Net Balance in $ %li",  (long)self.balance];

        if ([DBManager.shared deleteEntryWithID:self.entries[indexPath.row].entryID]) {
            self.entries = [[DBManager.shared loadEntries] mutableCopy];
            self.balance = 0;
            self.title = [NSString stringWithFormat:@"Net Balance in $ %li",  (long)self.balance]; //this one is for empty list
            [tableView reloadData];
        }
       
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"cell was touched %@", indexPath);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nav = segue.destinationViewController;
    AddItemViewController *addVC = nav.viewControllers[0];
    addVC.delegate = self;
    AddIncomeViewController *addIncomeVC = nav.viewControllers[0];
    addIncomeVC.delegate = self;
}

- (void)didSaveNewExpense:(NSString *)expense :(NSString *)expensePrice {
 
    if ([DBManager.shared openDatabase]){
        // add it to the table
    NSString *query = [NSString stringWithFormat: @"insert into entries (%@, %@, %@, %@) values (null, 0, '(%@)', \(%@))",self.EntryID,self.EntryType,self.EntryTitle,self.EntryAmount,expense,expensePrice];
  
        if (![DBManager.shared.database executeStatements:query]) {
            NSLog(@"Failed to insert initial data into the database.");
            NSLog(@"%@", [NSString stringWithFormat: @"(%@, %@)",[DBManager.shared.database lastError],[DBManager.shared.database lastErrorMessage]]);
        }
        [DBManager.shared.database close];
    }
    self.entries = [[DBManager.shared loadEntries] mutableCopy];
    self.balance = 0;
    [self.tableView reloadData];
  
}
// TODO
- (void)didSaveNewIncome:(NSString *)income :(NSString *)incomeValue {

    if ([DBManager.shared openDatabase]){
        // add it to the table
    NSString *query = [NSString stringWithFormat: @"insert into entries (%@, %@, %@, %@) values (null, 1, '(%@)', \(%@))",self.EntryID,self.EntryType,self.EntryTitle,self.EntryAmount,income,incomeValue];
  
        if (![DBManager.shared.database executeStatements:query]) {
            NSLog(@"Failed to insert initial data into the database.");
            NSLog(@"%@", [NSString stringWithFormat: @"(%@, %@)",[DBManager.shared.database lastError],[DBManager.shared.database lastErrorMessage]]);
        }
        [DBManager.shared.database close];
    }
    self.entries = [[DBManager.shared loadEntries] mutableCopy];
    self.balance = 0;
    [self.tableView reloadData];
}
 
@end
