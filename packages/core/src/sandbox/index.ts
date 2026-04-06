import { Console, Effect, Layer, PlatformError, Scope, ServiceMap, Stream } from "effect"
import {
  ChildProcess,
  ChildProcessSpawner
} from "effect/unstable/process"
import { BunServices } from '@effect/platform-bun'

export namespace Sandbox {
  export interface Interface {
    readonly init: (name: string) => Effect.Effect<void, PlatformError.PlatformError, Scope.Scope>
    readonly start: (name: string, branch: string) => Effect.Effect<void, PlatformError.PlatformError, Scope.Scope>
    readonly stop: (name: string, branch: string) => Effect.Effect<void, PlatformError.PlatformError, Scope.Scope>
    readonly execute: (command: string) => Effect.Effect<void, PlatformError.PlatformError, Scope.Scope>
    readonly prompt: (command: string) => Effect.Effect<void, PlatformError.PlatformError, Scope.Scope>
  }

  export class Service extends ServiceMap.Service<Service, Interface>()("@core/Sandbox") { }

  export const layer: Layer.Layer<Service, never, ChildProcessSpawner.ChildProcessSpawner> = Layer.effect(
    Service,
    Effect.gen(function*() {
      const { streamString } = yield* ChildProcessSpawner.ChildProcessSpawner

      const streamToConsole = (command: ChildProcess.StandardCommand) => {
        const stream = streamString(command)
        return Stream.runForEach(stream, (s) => Console.log(s))
      }

      /**
       * Initialize sandbox
       *
       * @since 0.0.0
       * @category method
       */
      const init = Effect.fn("Sandbox.init")(function*(name: string) {
        const command = ChildProcess.make({
          cwd: `./.adk/sandbox/${name}`,
        })`docker build -t ${name} .`

        yield* streamToConsole(command)
      })

      /**
       * Start sandbox
       *
       * @since 0.0.0
       * @category method
       */
      const start = Effect.fn("Sandbox.start")(function*(name: string, branch: string) {
        const command = ChildProcess.make`docker run -d --name ${name}-${branch} ${name}`

        yield* streamToConsole(command)
      })

      /**
       * Stop sandbox
       *
       * @since 0.0.0
       * @category method
       */
      const stop = Effect.fn("Sandbox.stop")(function*(name: string, branch: string) {
        const command = ChildProcess.make`docker rm -f ${name}-${branch}`

        yield* streamToConsole(command)
      })

      /**
       * Execute command in sandbox
       *
       * @since 0.0.0
       * @category method
       */
      const execute = Effect.fn("Sandbox.execute")(function*(command: string) {
        const cmd = ChildProcess.make(command)

        yield* streamToConsole(cmd)
      })

      /**
       * Prompt an agent in sandbox
       *
       * @since 0.0.0
       * @category method
       */
      const prompt = Effect.fn("Sandbox.prompt")(function*(command: string) {
        const cmd = ChildProcess.make(command)

        yield* streamToConsole(cmd)
      })

      return Service.of({
        init,
        start,
        stop,
        execute,
        prompt,
      })
    })
  )

  export const defaultLayer: Layer.Layer<Service, never, never> = layer.pipe(Layer.provide(BunServices.layer))
}
