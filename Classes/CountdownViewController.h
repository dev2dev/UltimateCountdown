
typedef enum
{
	GAME_WAITING = 0,
	GAME_STARTING,
	GAME_PLAYING,
}
GameState;

typedef enum
{
	PLAYER_WAITING = 0,
	PLAYER_PRESSED,
	PLAYER_RELEASED,
}
PlayerState;

@interface CountdownViewController : UIViewController
{
	UIButton* player1Button;
	UIButton* player2Button;
	UILabel* clock1Label;
	UILabel* clock2Label;
	UILabel* player1Label;
	UILabel* player2Label;
	UILabel* player1ScoreLabel;
	UILabel* player2ScoreLabel;

	GameState gameState;
	PlayerState player1State;
	PlayerState player2State;
	double startTime;
	double speed;      // how fast the clock counts down (in milliseconds)
	int maxCount;      // where the clock starts counting
	int minCount;      // how far we'll go into the negative numbers
	int count;         // current counter value
	int player1Count;  // when the player released the button
	int player2Count;
	int player1Score;
	int player2Score;
	
	NSTimer* timer;
	UIColor* redColor;
}

@property (nonatomic, retain) IBOutlet UIButton* player1Button;
@property (nonatomic, retain) IBOutlet UIButton* player2Button;
@property (nonatomic, retain) IBOutlet UILabel* clock1Label;
@property (nonatomic, retain) IBOutlet UILabel* clock2Label;
@property (nonatomic, retain) IBOutlet UILabel* player1Label;
@property (nonatomic, retain) IBOutlet UILabel* player2Label;
@property (nonatomic, retain) IBOutlet UILabel* player1ScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel* player2ScoreLabel;

- (IBAction)player1ButtonDown;
- (IBAction)player2ButtonDown;
- (IBAction)player1ButtonUp;
- (IBAction)player2ButtonUp;

@end
