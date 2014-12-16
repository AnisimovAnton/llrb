unit UnLLRB;

interface

type
  PRBNode = ^TRBNode;
  TRBNode = record
    Left: PRBNode;
    Right: PRBNode;
    isRed: Boolean;
    Key: Integer;
  end;

  TLLRB = class
  private
    root: PRBNode;
//    procedure Insert(Node: PRBNode; key: Integer);
//    procedure Insert(key: Integer);
  public
    function Search(key: Integer): PRBNode;
    procedure Insert(key: Integer); overload;
    function Insert(Parent: PRBNode; key: Integer): PRBNode; overload;
  end;

  TLeftLeaningRedBlackTree = TLLRB;

implementation

function NewNode(const key: Integer): PRBNode;
begin
  New(Result);
  Result.Key := key;
  Result.isRed := True;
end;

function isRed(Node: PRBNode): Boolean;
begin
  if not Assigned(Node) then
    Result := False
  else
    result := Node.isRed;
end;

function rotateLeft(Parent: PRBNode): PRBNode;
begin
  Result := Parent.Right;
  Parent.Right := Result.Left;
  Result.Left := Parent;
  Result.isRed := Parent.isRed;
  Parent.isRed := True;
end;

function rotateRight(Parent: PRBNode): PRBNode;
begin
  Result := Parent.Left;
  Parent.Left := Result.Right;
  Result.Right := Parent;
  Result.isRed := Parent.isRed;
  Parent.isRed := True;
end;

procedure flipColors(Parent: PRBNode);
begin
  Parent.isRed := not Parent.isRed;
  Parent.Left.isRed := not Parent.Left.isRed;
  Parent.Right.isRed := not Parent.Right.isRed;
end;

function TLLRB.Search(key: Integer): PRBNode;
begin
  Result := root;
  while Assigned(Result) do
  begin
    if key = Result.Key then Exit;
    if key < Result.Key then
      Result := Result.Left
    else
      Result := Result.Right;
  end;
end;

procedure TLLRB.Insert(key: Integer);
begin
  root := Insert(root, key);
  root.isRed := False;
end;

function TLLRB.Insert(Parent: PRBNode; key: Integer): PRBNode;
begin
  if not Assigned(Parent) then
  begin
    Result := NewNode(key);
    Exit;
  end;
  if key = Parent.Key then Exit;
  if key < Parent.Key then
    Parent.Left := Insert(Parent.Left, key)
  else
    Parent.Right := Insert(Parent.Right, key);
  if Parent.Right.isRed and not Parent.Left.isRed then
    Parent := rotateLeft(Parent);
  if Parent.Left.isRed and Parent.Left.Left.isRed then
    Parent := rotateRight(Parent);
  if Parent.Left.isRed and Parent.Right.isRed then
    flipColors(Parent);
  Result := Parent;
end;

end.
