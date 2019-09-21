import * as express from 'express';

export class Server {

    public static start(port: number = 5000) {
        this.app = express();
        this.app.get('/', (req: express.Request, res: express.Response) =>  {
            res.send('service msakextagservice-namemsakextag is running');
        });
        this.app.listen(port, () => {
            console.log(`app listening on port ${port}...`);
        });
    }

    private static app: express.Express;

}
